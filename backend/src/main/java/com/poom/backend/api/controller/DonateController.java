package com.poom.backend.api.controller;

import com.poom.backend.api.service.donation.DonationService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;

@RestController
@Api(tags = "후원 관련 API")
@RequiredArgsConstructor
public class DonateController {

    private final DonationService donationService;

    // 1. 내가 한 후원의 목록을 조회합니다.
    @GetMapping("/api/members/donations")
    @ApiOperation(value = "나의 후원 내역 조회", notes = "<strong>페이지의 크기와 순번</strong>을 입력받아 나의 후원 내역을 조회합니다.")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(조회 성공)"),
            @ApiResponse(code = 204, message = "NO CONTENT(데이터 없음)"),
            @ApiResponse(code = 401, message = "UNAUTHORIZED(권한 없음)"),
            @ApiResponse(code = 500, message = "서버에러")
    })
    public ResponseEntity<?> getMyDonationList(HttpServletRequest request,
                                              @RequestParam int size,
                                              @RequestParam int page){
        return ResponseEntity.status(200)
                .body(donationService.getMyDonationList(request, size, page));
    }
}
