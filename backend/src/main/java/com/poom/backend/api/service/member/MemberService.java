package com.poom.backend.api.service.member;

import com.poom.backend.api.dto.member.SignupCond;
import com.poom.backend.api.dto.member.memberInfoRes;
import com.poom.backend.db.entity.Member;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;

public interface MemberService {
    Member signUp(SignupCond signupCond);
    String getUserIdFromHeader(HttpServletRequest request);

    void changeMemberStatus(String id);

    memberInfoRes getMemberInfo(HttpServletRequest request);

    memberInfoRes updateMemberInfo(HttpServletRequest request, MultipartFile profileImage, String nickname);
}
