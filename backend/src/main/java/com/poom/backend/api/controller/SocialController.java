package com.poom.backend.api.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.poom.backend.api.service.social.KakaoService;
import io.swagger.annotations.Api;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletResponse;

@RestController
@RequiredArgsConstructor
@Api(tags = "소셜 API")
public class SocialController {

    private final KakaoService kakaoService;

    @GetMapping("/oauth/kakao")
    public ResponseEntity<?> kakaoLogin(@RequestParam String code, HttpServletResponse response){
        try {
            return ResponseEntity.status(200).body(kakaoService.kakaoLogin(code, response));
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
    }
}
