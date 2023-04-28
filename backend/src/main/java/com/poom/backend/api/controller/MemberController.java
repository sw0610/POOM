package com.poom.backend.api.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;

@RestController
@Api(tags = "회원 API")
public class MemberController {

    @GetMapping("/members/logout")
    @ApiOperation(value = "로그 아웃", notes = "<strong>access_token</strong>을 입력받아 로그아웃 처리를 합니다.")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(로그 아웃 성공)"),
            @ApiResponse(code = 400, message = "BAD REQUEST(로그아웃 실패)"),
            @ApiResponse(code = 500, message = "서버 오류")
    })
    public ResponseEntity<?> logout(HttpServletRequest request){

        return null;
    }

}
