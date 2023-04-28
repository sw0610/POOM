package com.poom.backend.config.jwt;

import org.springframework.security.config.annotation.SecurityConfigurerAdapter;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.DefaultSecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

public class JwtSecurityConfig extends SecurityConfigurerAdapter<DefaultSecurityFilterChain, HttpSecurity> {
    private TokenProvider tokenProvider;
    public JwtSecurityConfig(TokenProvider tokenProvider) {
        this.tokenProvider = tokenProvider;
    }
    //  Spring Security의 HttpSecurity를 구성
    @Override
    public void configure(HttpSecurity http) {
        http.addFilterBefore( // security logic에 before 필터로 등록한다.
                // JwtFilter는 Jwt 토큰을 가지고 인증을 수행하는 필터
                new JwtFilter(tokenProvider),
                //  JwtFilter가 요청을 먼저 가로채어서 Jwt 토큰을 검증하고 인증 정보를 SecurityContext에 설정
                UsernamePasswordAuthenticationFilter.class
        );
    }
}

