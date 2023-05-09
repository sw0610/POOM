package com.poom.backend.config.jwt;

import com.poom.backend.db.entity.Member;
import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Arrays;
import java.util.Base64;
import java.util.Collection;
import java.util.Date;
import java.util.stream.Collectors;

@Slf4j
@Component
public class TokenProvider implements InitializingBean {
    private final String secret;
    private final long tokenValidityInMilliseconds;
    private final String AUTHORITIES_KEY;
    private Key key;

    public TokenProvider(@Value("${jwt.secret}") String secret,
                         @Value("${jwt.token-validity-in-minutes}") long tokenValidityInMinutes) {
        this.secret = secret;
        this.tokenValidityInMilliseconds = tokenValidityInMinutes * 60 * 1000;
        this.AUTHORITIES_KEY = "auth";
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        byte[] keyBytes = Decoders.BASE64.decode(secret); // secret 변수에서 BASE64로 인코딩된 문자열을 디코딩하여 byte 배열로 변환합니다.
        this.key = Keys.hmacShaKeyFor(keyBytes); // keyBytes를 기반으로 SecretKey 객체를 생성
    }

    private String createToken(Member member, long times) {
        long now = (new Date()).getTime();
        Date validity = new Date(now + this.tokenValidityInMilliseconds * times); // 만료 일자를 계산한다.

        String authorities = member.getRoles().stream().map(role -> role.name()).collect(Collectors.joining(","));
        log.info(" member Id = {}", member.getId());
        return Jwts.builder()
                .setSubject(member.getId()) // meber의 id 값을 기준으로 jwt 토큰을 생성
                .claim(AUTHORITIES_KEY, authorities) // 권한 목록
                .signWith(key, SignatureAlgorithm.HS512) // 서명
                .setExpiration(validity) // 만료 일자 지정
                .compact();
    }

    //  Member 객체를 전달하고, 인자로 1을 전달하여 만료 시간을 1배로 설정한 후, 생성된 JWT Access Token을 반환하는 메소드
    public String createAccessToken(Member member) {
        return createToken(member, 1);
    }

    // refresh token을 생성하는 역할 createToken 메소드를 호출하여 member 정보와 14일 간의 유효기간을 가진 토큰을 생성
    public String createRefreshToken(Member member) {
        return createToken(member, 14*24*2);
    }

    public Authentication getAuthentication(String token){
        // payload 정보를 가지고 있는 Claims 객체를 추출
        Claims claims = Jwts.parserBuilder()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(token)
                .getBody();

        // GrantedAuthority(role) 객체들의 리스트 생성
        Collection<? extends GrantedAuthority> authorities =
                Arrays.stream(claims.get(AUTHORITIES_KEY).toString().split(","))
                        .map(SimpleGrantedAuthority::new)
                        .collect(Collectors.toList());

        // User 객체 생성
        User principal = new User(claims.getSubject(), " ", authorities);
        return new UsernamePasswordAuthenticationToken(principal,token, authorities);
    }

    public boolean validateToken(String token) { // 토큰을 받아 유효성 검사를 실행
        try {
            // key 값을 사용하여 파싱을 수행
            Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token);
            return true;
        } catch (io.jsonwebtoken.security.SecurityException | MalformedJwtException e) {
            log.info("잘못된 JWT 서명입니다.");
        } catch (ExpiredJwtException e) {
            log.info("만료된 JWT 토큰입니다.");
        } catch (UnsupportedJwtException e) {
            log.info("지원되지 않는 JWT 토큰입니다.");
        } catch (IllegalArgumentException e) {
            log.info("JWT 토큰이 잘못되었습니다.");
        }
        return false;
    }
}
