package com.poom.backend.api.service.oauth;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.poom.backend.db.entity.Member;

import javax.servlet.http.HttpServletRequest;

public interface OauthService {
    String login(String providerName, String code) throws JsonProcessingException;
    String getTokenResponse(String code);
    void logout(HttpServletRequest request);
}
