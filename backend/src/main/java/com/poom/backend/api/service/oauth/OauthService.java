package com.poom.backend.api.service.oauth;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.poom.backend.api.dto.member.MemberDto;
import com.poom.backend.db.entity.Member;

import javax.servlet.http.HttpServletRequest;

public interface OauthService {
    MemberDto login(String providerName, String code) throws JsonProcessingException;
//    String getTokenResponse(String code);
    void logout(HttpServletRequest request);
    MemberDto generateToken(Member member);
    boolean checkAdmin(String token);
}
