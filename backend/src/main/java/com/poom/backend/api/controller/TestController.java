package com.poom.backend.api.controller;

import com.poom.backend.api.dto.member.SignupCond;
import com.poom.backend.api.service.member.MemberService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import lombok.RequiredArgsConstructor;

import lombok.extern.log4j.Log4j;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Api(tags = "테스트 API")
@RestController
@RequiredArgsConstructor
@Slf4j
public class TestController {

    private final MemberService memberService;


    @GetMapping("/test/log")
    @ApiOperation(value = "로그 테스트", notes = "<strong>로그 출력</strong>")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(조회 성공)"),
            @ApiResponse(code = 204, message = "NO CONTENT(정보 없음)"),
            @ApiResponse(code = 400, message = "BAD REQUEST(조회 실패)"),
            @ApiResponse(code = 500, message = "서버 오류")
    })
    public ResponseEntity<?> logTest(){
        // pagination이 포함 된 ItemList 가져오기
        log.info("log test run");
        return ResponseEntity.status(200).build();
    }

    @PostMapping("/test/token")
    @ApiOperation(value = "토큰 테스트", notes = "<strong>email을 입력받아 테스트를 위한 엑세스 토큰</strong>을 발급합니다.")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(조회 성공)"),
            @ApiResponse(code = 500, message = "서버 오류")
    })
    public ResponseEntity<?> tokenTest(@RequestParam String email){
        memberService.signUp(new SignupCond(email));
        return ResponseEntity.status(200).build();
    }
}
