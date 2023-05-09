package com.poom.backend.api.service.member;

import com.poom.backend.api.dto.member.SignupCond;
import com.poom.backend.api.dto.member.MemberInfoRes;
import com.poom.backend.api.service.ipfs.IpfsService;
import com.poom.backend.config.jwt.JwtFilter;
import com.poom.backend.config.jwt.TokenProvider;
import com.poom.backend.db.entity.Member;
import com.poom.backend.db.entity.Shelter;
import com.poom.backend.db.repository.MemberRepository;
import com.poom.backend.db.repository.ShelterRepository;
import com.poom.backend.exception.BadRequestException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService{
    private final MemberRepository memberRepository;
    private final ShelterRepository shelterRepository;
    private final TokenProvider tokenProvider;
    private final IpfsService ipfsService;

    @Override
    public Member signUp(SignupCond signupCond) {
        Optional<Member> member = memberRepository.findMemberByEmail(signupCond.getEmail());
        if(!member.isPresent()){
            member = Optional.of(memberRepository.save(signupCond.toMember()));
        }
        return member.get();
    }

    @Override
    public String getMemberIdFromHeader(HttpServletRequest request) {
        String token = request.getHeader("Authorization");
        // 액세스 토큰 문자열에서 "Bearer " 문자열을 제거하고, 나머지 액세스 토큰 문자열을 인자로 전달
        Authentication authentication = tokenProvider.getAuthentication(token.substring(7));
        // 회원 컬렉션의 id
        return authentication.getName();
    }

    //
    @Override
    public void changeMemberStatusToWithdrawal(String id) {
        Member member = memberRepository.findById(id)
                .orElseThrow(()-> new BadRequestException("회원 정보가 없습니다."));
        if(member.isWithdrawal()) throw new BadRequestException("이미 탈퇴 신청한 회원입니다.");
        member.setWithdrawal(true);
        memberRepository.save(member);
    }

    @Override
    public MemberInfoRes getMemberInfo(HttpServletRequest request) {
        String memberId = getMemberIdFromHeader(request);
        Member member = memberRepository.findById(memberId)
                .orElseThrow(()-> new BadRequestException("회원 정보가 없습니다."));
        Optional<Shelter> shelter = shelterRepository.findShelterByAdminId(memberId);

        MemberInfoRes res = new MemberInfoRes();
        res.setMemberInfo(member);
        if(shelter.isPresent()) res.setShelterInfo(shelter.get());
        return res;
    }

    @Override
    public MemberInfoRes updateMemberInfo(HttpServletRequest request, MultipartFile profileImage, String nickname) {
        Member member = memberRepository.findById(getMemberIdFromHeader(request))
                .orElseThrow(()->new BadRequestException("회원 정보가 없습니다."));
        if(profileImage != null || !profileImage.isEmpty()) {
            String hash = ipfsService.uploadImage(profileImage);
            member.setProfileImgUrl(hash);
        }
        if(nickname != null) {
            member.setNickname(nickname);
        }
        memberRepository.save(member);
        return null;
    }

    @Override
    public HttpHeaders getHeader(String accessToken, String refreshToken) {
        HttpHeaders headers = new HttpHeaders();
        headers.add("accessToken", "Bearer "+accessToken);
        headers.add("refreshToken", "Bearer "+refreshToken);
        return headers;
    }

    @Override
    public String getToken(HttpServletRequest request) {
        String bearerToken = request.getHeader(JwtFilter.AUTH_HEADER);
//      System.out.println(bearerToken);
        // ACCESS_HEADER 상수로 정의된 문자열을 사용하여 HTTP request header에서 "Bearer "로 시작하는 Authorization 헤더를 검색합니다.
        // 검색된 문자열이 null이 아니며, "Bearer "로 시작한다면 실제 인증 토큰 정보를 추출하여 반환하고, 그렇지 않다면 null을 반환합니다.
        if (StringUtils.hasText(bearerToken) && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }

        return null;
    }
}
