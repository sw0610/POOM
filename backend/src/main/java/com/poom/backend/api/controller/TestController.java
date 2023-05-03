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
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;

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

    @PostMapping("/test/image")
    @ApiOperation(value = "토큰 테스트", notes = "<strong>email을 입력받아 테스트를 위한 엑세스 토큰</strong>을 발급합니다.")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(조회 성공)"),
            @ApiResponse(code = 500, message = "서버 오류")
    })
    public ResponseEntity<?> tokenTest(@RequestPart MultipartFile file){
        try {
            // 이미지 파일 읽기
            BufferedImage originalImage = ImageIO.read(file.getInputStream());

            // 글자 쓰기
            Graphics2D graphics = originalImage.createGraphics();
            graphics.setColor(Color.GREEN);
            graphics.setFont(new Font("Malgun Gothic", Font.BOLD, 30));
            graphics.drawString("#" + 100, 10, 30);

            String name = "진수형 카와이";
            int x = originalImage.getWidth() - graphics.getFontMetrics().stringWidth(name) - 10; // x 좌표 지정
            int y = originalImage.getHeight() - 10; // y 좌표 지정
            graphics.drawString(name, x, y);

            // 이미지 파일 저장
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(originalImage, "png", baos);
            byte[] bytes = baos.toByteArray();
            String fileName = file.getOriginalFilename();
            String modifiedFileName = "signed_" + fileName;
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.IMAGE_PNG);
            headers.setContentDispositionFormData("attachment", modifiedFileName);

            return new ResponseEntity<>(bytes, headers, HttpStatus.OK);
        } catch (IOException e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
