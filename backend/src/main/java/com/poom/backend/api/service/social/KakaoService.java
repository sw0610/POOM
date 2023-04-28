package com.poom.backend.api.service.social;

import com.fasterxml.jackson.core.JsonProcessingException;

import javax.servlet.http.HttpServletResponse;

public interface KakaoService {
    String kakaoLogin(String code, HttpServletResponse response) throws JsonProcessingException;
}
