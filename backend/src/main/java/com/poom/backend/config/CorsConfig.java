package com.poom.backend.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

@Configuration
public class CorsConfig {
    // 모든 Origin을 허용하고, 요청 메소드와 요청 헤더도 모두 허용하며, 응답으로 보낼 헤더를 설정하여 CORS를 구성 이를 통해 다른 도메인에서 해당 서버의 API를 호출할 수 있도록 허용
    @Bean
    public CorsFilter corsFilter() {
        // 객체 생성
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        CorsConfiguration config = new CorsConfiguration();
        // 자격 증명을 허용하는지 여부를 설정
        config.setAllowCredentials(true);
        //  메소드를 사용하여 클라이언트에게 노출할 응답 헤더를 설정
        config.addExposedHeader("accessToken");
        config.addExposedHeader("refreshToken");
        config.addExposedHeader("access_token");
        config.addExposedHeader("X-Rate-Limit-Retry-After"); // 요청 횟수 초과시 다음 요청까지 대기 시간 (초)
        config.addExposedHeader("X-Rate-Limit-Remaining"); // 남은 요청 횟수
        // *를 설정하여 모든 Origin을 허용합니다.
        config.addAllowedOriginPattern("*");
        // *를 설정하여 모든 헤더를 허용합니다.
        config.addAllowedHeader("*");
        // *를 설정하여 모든 HTTP 메소드를 허용합니다.
        config.addAllowedMethod("*");
        source.registerCorsConfiguration("/**", config);
        return new CorsFilter(source);
    }
}