package com.poom.backend.api.service.member;

import com.poom.backend.db.entity.Member;

import javax.servlet.http.HttpServletRequest;

public interface MemberService {
    Member signUp();
    String getUserIdFromHeader(HttpServletRequest request);
}
