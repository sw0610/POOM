package com.poom.backend.api.service.member;

import com.poom.backend.api.dto.member.SignupCond;
import com.poom.backend.api.dto.member.MemberInfoRes;
import com.poom.backend.db.entity.Member;
import org.springframework.http.HttpHeaders;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;

public interface MemberService {
    Member signUp(SignupCond signupCond);
    String getMemberIdFromHeader(HttpServletRequest request);
    void changeMemberStatusToWithdrawal(String id);
    MemberInfoRes getMemberInfo(HttpServletRequest request);
    MemberInfoRes updateMemberInfo(HttpServletRequest request, MultipartFile profileImage, String nickname);
    HttpHeaders getHeader(String accessToken, String refreshToken);
    // 서명 확인
    boolean verifySignature(String memberAddress, String signature, String message);
    String getToken(HttpServletRequest request);
}
