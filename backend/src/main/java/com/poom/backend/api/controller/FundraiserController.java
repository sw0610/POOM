package com.poom.backend.api.controller;

import com.poom.backend.api.dto.fundraiser.OpenFundraiserCond;
import com.poom.backend.api.service.fundraiser.FundraiserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@RestController
@Api(tags = "후원 모집 관련 API")
@RequiredArgsConstructor
public class FundraiserController {
    private final FundraiserService fundraiserService;


    @GetMapping("/members/shelters/fundraisers")
    @ApiOperation(value = "나의 후원 모집 조회", notes = "<strong>나의 후원 모집</strong>을 조회합니다.")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(조회 성공)"),
            @ApiResponse(code = 204, message = "NO CONTENT(후원 모집 없음)"),
            @ApiResponse(code = 400, message = "BAD REQUEST(요청 실패)"),
            @ApiResponse(code = 401, message = "UNAUTHORIZED(권한 없음)"),
            @ApiResponse(code = 500, message = "서버에러")
    })
    public ResponseEntity<?> getMyFundraiserList(HttpServletRequest request,
                                                 @RequestParam int size,
                                                 @RequestParam int page,
                                                 @RequestParam boolean isClosed){
        return ResponseEntity.status(200).body(fundraiserService.getMyFundraiserList(request, size, page, isClosed));
    }

    @PostMapping("/fundraiser/nft")
    @ApiOperation(value = "후원 모집시 NFT 이미지를 생성", notes = "<strong>대표 사진</strong>을 입력받아 NFT 이미지를 생성합니다.")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(생성 성공)"),
            @ApiResponse(code = 400, message = "BAD REQUEST(요청 실패)"),
            @ApiResponse(code = 401, message = "UNAUTHORIZED(권한 없음)"),
            @ApiResponse(code = 500, message = "서버에러")
    })
    public ResponseEntity<?> openFundraiser(@RequestPart("mainImage") MultipartFile mainImage){
        // 파이썬 서버에 mainImage를 전송하고 NFT 이미지를 받습니다.
        MultipartFile result = null;
        return ResponseEntity.status(200).body(result);
    }

    @PostMapping("/fundraiser/open")
    @ApiOperation(value = "후원 모집 생성", notes = "<strong>후원 모집 정보</strong>를 받아 모집을 등록합니다.")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(생성 성공)"),
            @ApiResponse(code = 400, message = "BAD REQUEST(요청 실패)"),
            @ApiResponse(code = 401, message = "UNAUTHORIZED(권한 없음)"),
            @ApiResponse(code = 500, message = "서버에러")
    })
    public ResponseEntity<?> openFundraiser(HttpServletRequest request,
                                            @RequestPart("dogImages") List<MultipartFile> dogImages,
                                            @RequestPart("nftImage") MultipartFile nftImage,
                                            @RequestPart("mainImage") MultipartFile mainImage,
                                            @RequestBody OpenFundraiserCond openFundraiserCond){
        fundraiserService.createFundraiser(request, dogImages, nftImage, mainImage, openFundraiserCond);
        return ResponseEntity.status(200).build();
    }

    @GetMapping("/fundraisers/size={}&page={}&isClosed={}")
    @ApiOperation(value = "후원 모집 목록 조회", notes = "<strong>페이지 검색 조건</strong>을 입력받아 후원 모집을 조회합니다.")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(조회 성공)"),
            @ApiResponse(code = 204, message = "NO CONTENT(후원 모집 없음)"),
            @ApiResponse(code = 400, message = "BAD REQUEST(요청 실패)"),
            @ApiResponse(code = 401, message = "UNAUTHORIZED(권한 없음)"),
            @ApiResponse(code = 500, message = "서버에러")
    })
    public ResponseEntity<?> getFundraiserList(@RequestParam int size,
                                               @RequestParam int page,
                                               @RequestParam boolean isClosed){
        return ResponseEntity.status(200).body(fundraiserService.getFundraiserList(size, page, isClosed));
    }

    @GetMapping("/fundraisers/{fundraiserId}")
    @ApiOperation(value = "후원 모집 상세 조회", notes = "<strong>후원 ID</strong>를 입력받아 후원 모집을 조회합니다.")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(조회 성공)"),
            @ApiResponse(code = 204, message = "NO CONTENT(후원 모집 없음)"),
            @ApiResponse(code = 400, message = "BAD REQUEST(요청 실패)"),
            @ApiResponse(code = 401, message = "UNAUTHORIZED(권한 없음)"),
            @ApiResponse(code = 500, message = "서버에러")
    })
    public ResponseEntity<?> getFundraiserDetail(@PathVariable Long fundraiserId){
        return ResponseEntity.status(200).body(fundraiserService.getFundraiserDetail(fundraiserId));
    }

}
