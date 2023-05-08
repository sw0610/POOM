package com.poom.backend.api.controller;

import com.poom.backend.api.dto.nft.NftIssueCond;
import com.poom.backend.api.service.nft.NFTService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;

@RestController
@Api(tags = "NFT 관련 API")
@RequiredArgsConstructor
@Slf4j
public class NFTController {

    private final NFTService nftService;

    @GetMapping("/members/nfts")
    @ApiOperation(value = "멤버의 NFT를 조회합니다.", notes = "<strong>멤버의 ID와 페이지 정보를 입력받아</strong> NFT 목록을 조회합니다.")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(조회 성공)"),
            @ApiResponse(code = 204, message = "NO CONTENT(보호소 정보 없음)"),
            @ApiResponse(code = 401, message = "UNAUTHORIZED(권한 없음)"),
            @ApiResponse(code = 500, message = "서버에러")
    }) // /size={}&page={}&memberId={}
    public ResponseEntity<?> getNftList(@RequestParam int size,
                                        @RequestParam int page,
                                        @RequestParam String memberId){
        return ResponseEntity.status(200).body(nftService.getNFTList(size, page, memberId));
    }

    @GetMapping("/donations/nft/issued")
    @ApiOperation(value = "NFT를 발급합니다.", notes = "<strong>후원 ID와 메타마스크 지갑 정보</strong>를 입력받아 NFT를 발급합니다.")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(조회 성공)"),
            @ApiResponse(code = 204, message = "NO CONTENT(보호소 정보 없음)"),
            @ApiResponse(code = 401, message = "UNAUTHORIZED(권한 없음)"),
            @ApiResponse(code = 500, message = "서버에러")
    }) // /size={}&page={}&memberId={}
    public ResponseEntity<?> issueNft(HttpServletRequest request, @RequestBody NftIssueCond nftIssueCond){
        nftService.nftIssue(request, nftIssueCond);
        return ResponseEntity.status(200).build();
    }
}
