package com.poom.backend.api.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.poom.backend.api.service.member.MemberService;
import com.poom.backend.api.service.oauth.OauthService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Api(tags = "회원 API")
@RequiredArgsConstructor
@Slf4j
public class MemberController {

    private final OauthService oauthService;
    private final MemberService memberService;

    // 1. 로그인 (카카오 소셜 로그인만을 지원합니다.)
    @GetMapping("/oauth/kakao")
    @ApiOperation(value = "로그인(카카오)", notes = "<strong>code</strong>을 입력받아 로그아웃 처리를 합니다.")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(로그 아웃 성공)"),
            @ApiResponse(code = 400, message = "BAD REQUEST(로그아웃 실패)"),
            @ApiResponse(code = 500, message = "서버 오류")
    })
    public ResponseEntity<?> kakaoLogin(@RequestParam String code){
        try {
            return ResponseEntity.status(200).body(oauthService.login("kakao",code));
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
    }

    // 2. 로그아웃
    @GetMapping("/logout")
    @ApiOperation(value = "로그아웃(카카오)", notes = "<strong>카카오 리다이렉트</strong>을 입력받아 로그아웃 처리를 합니다.")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(로그 아웃 성공)"),
            @ApiResponse(code = 500, message = "서버 오류")
    })
    public ResponseEntity<?> kakaoLogout(@RequestParam Long id){
        // redis에서 refresh 토큰을 삭제합니다.
        log.info(id+"");

        return ResponseEntity.status(200).build();
    }
    // 3. 회원 탈퇴

    // 4. 내 정보 조회

    // 5. 내 정보 수정

}
