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
import org.web3j.crypto.ECDSASignature;
import org.web3j.crypto.Hash;
import org.web3j.crypto.Keys;
import org.web3j.crypto.Sign;
import org.web3j.utils.Numeric;

import javax.servlet.http.HttpServletRequest;
import java.math.BigInteger;
import java.util.Arrays;
import java.util.Objects;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService{
    private final MemberRepository memberRepository;
    private final ShelterRepository shelterRepository;
    private final TokenProvider tokenProvider;
    private final IpfsService ipfsService;
    // PERSONAL_MESSAGE_PREFIX 선언
    public static final String PERSONAL_MESSAGE_PREFIX = "\u0019Ethereum Signed Message:\n";

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
        if(!Objects.isNull(profileImage)) {
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
    public boolean verifySignature(String memberAddress, String signature, String message) {
        // 메시지의 길이를 결합하여 새 문자열 prefix를 만듭니다. 서명 메시지에 대한 prefix 역할을 합니다.
        String prefix = PERSONAL_MESSAGE_PREFIX + message.length();
        // 문자열을 바이트 배열로 변환한 다음, SHA3 알고리즘을 사용하여 해시 값을 계산합니다.
        byte[] msgHash = Hash.sha3((prefix + message).getBytes());

        // 서명을 16진수 문자열에서 바이트 배열로 변환합니다.
        byte[] signatureBytes = Numeric.hexStringToByteArray(signature);

        // v 값을 계산합니다. 서명 바이트 배열에서 마지막 바이트는 v 값으로 사용됩니다. 그러나 v 값은 27 미만이 될 수 있으므로, 27을 더하여 v 값을 조정합니다.
        byte v = signatureBytes[64];
        if (v < 27) {
            v += 27;
        }
        // 서명 바이트 배열에서 r 값과 s 값의 일부를 추출하여 ECDSA 서명 데이터를 만듭니다. 이 데이터는 서명된 메시지의 검증에 사용됩니다
        Sign.SignatureData sd =
                new Sign.SignatureData(
                        v,
                        (byte[]) Arrays.copyOfRange(signatureBytes, 0, 32),
                        (byte[]) Arrays.copyOfRange(signatureBytes, 32, 64));
        // addressRecovered 복구된 주소를 저장할 변수이고, match는 서명된 주소가 memberAddress와 일치하는지 여부를 저장하는 변수입니다.
        String addressRecovered = null;
        boolean match = false;

        // Iterate for each possible key to recover
        // 모든 가능한 공개 키에 대해 복구를 시도합니다. . 이 공개 키는 이전에 서명된 메시지와 연관된 개인 키로부터 생성된 공개 키를 나타냅니다.
        for (int i = 0; i < 4; i++) {
            // 복구에 실패하면 null을 반환합니다.
            BigInteger publicKey =
                    Sign.recoverFromSignature(
                            (byte) i,
                            new ECDSASignature(
                                    new BigInteger(1, sd.getR()), new BigInteger(1, sd.getS())),
                            msgHash);
            // 키가 성공적으로 복구되면, Keys.getAddress() 메서드를 호출하여 복구된 공개 키에 대한 주소를 가져옵니다.
            if (publicKey != null) {
                addressRecovered = "0x" + Keys.getAddress(publicKey);
                //  복구된 주소가 memberAddress와 일치하는지 확인합니다. 이 경우, match 변수를 true로 설정하고 루프를 종료합니다.
                if (addressRecovered.equals(memberAddress)) {
                    match = true;
                    break;
                }
            }
        }
        return memberAddress.equals(addressRecovered);
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
