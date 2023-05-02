package com.poom.backend.api.service.member;

import com.poom.backend.api.dto.member.SignupCond;
import com.poom.backend.api.dto.member.memberInfoRes;
import com.poom.backend.config.jwt.TokenProvider;
import com.poom.backend.db.entity.Member;
import com.poom.backend.db.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;

@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService{
    private final MemberRepository memberRepository;
    private final TokenProvider tokenProvider;

    @Override
    public Member signUp(SignupCond signupCond) {
        Member member = memberRepository.findMemberByEmail(signupCond
                .getEmail()).orElseThrow();
        if(member == null){

        }
        return member;
    }

    @Override
    public String getUserIdFromHeader(HttpServletRequest request) {
        String token = request.getHeader("Authrization");
        // 액세스 토큰 문자열에서 "Bearer " 문자열을 제거하고, 나머지 액세스 토큰 문자열을 인자로 전달
        Authentication authentication = tokenProvider.getAuthentication(token.substring(7));
        // 회원 컬렉션의 id
        return authentication.getName();
    }

    @Override
    public void changeMemberStatus(String id) {

    }

    @Override
    public memberInfoRes getMemberInfo(HttpServletRequest request) {
        return null;
    }

    @Override
    public memberInfoRes updateMemberInfo(HttpServletRequest request, MultipartFile profileImage, String nickname) {
        return null;
    }

}
