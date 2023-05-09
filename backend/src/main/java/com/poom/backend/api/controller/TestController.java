package com.poom.backend.api.controller;

import com.poom.backend.api.dto.member.SignupCond;
import com.poom.backend.api.dto.shelter.ShelterAuthCond;
import com.poom.backend.api.dto.shelter.ShelterAuthMMCond;
import com.poom.backend.api.service.mattermost.MattermostService;
import com.poom.backend.api.service.member.MemberService;
import com.poom.backend.config.jwt.TokenProvider;
import com.poom.backend.db.entity.Member;
import com.poom.backend.db.entity.Shelter;
import com.poom.backend.db.repository.MemberRepository;
import com.poom.backend.enums.ShelterStatus;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import lombok.RequiredArgsConstructor;

import lombok.extern.log4j.Log4j;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.*;
import java.util.List;

@Api(tags = "테스트 API")
@RestController
@RequiredArgsConstructor
@Slf4j
public class TestController {

    private final MemberService memberService;
    private final MattermostService mattermostService;
    private final MemberRepository memberRepository;
    private final TokenProvider tokenProvider;


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
    @ApiOperation(value = "토큰 발급 테스트", notes = "")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(조회 성공)"),
            @ApiResponse(code = 500, message = "서버 오류")
    })
    public ResponseEntity<?> generateTokenTest(){
        Member member = memberRepository.findById("644f55055989655e694476b1").get();
        String token = tokenProvider.createAccessToken(member);
        return ResponseEntity.status(200).body("Bearer "+token);
    }

    @PostMapping("/auth/test/token")
    @ApiOperation(value = "권한 테스트", notes = "")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(조회 성공)"),
            @ApiResponse(code = 500, message = "서버 오류")
    })
    public ResponseEntity<?> tokenAuthTest(){
        log.info("성공");
        return ResponseEntity.status(200).build();
    }



    @PostMapping("/test/image")
    @ApiOperation(value = "이미지 변환 테스트", notes = "")
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

    @PostMapping("/test/mattermost/message2")
    @ApiOperation(value = "메타모스트 메세지 파이널 테스트", notes = "<strong>email을 입력받아 테스트를 위한 엑세스 토큰</strong>을 발급합니다.")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(조회 성공)"),
            @ApiResponse(code = 500, message = "서버 오류")
    })
    public void mmFinalMessageTest(){
        String image2 = "https://www.kukinews.com/data/kuk/image/2023/01/18/kuk202301180113.680x.9.jpg";
        String image3 = "https://ipfs.io/ipfs/QmV637KHwPNyd7YzgSaL5Fdn6rk6AsD1cKFbFm3yYmt7QH";

        Shelter shelter = Shelter.builder()
                .id("shelter ID")
                .adminId("6448d2f0577f215b3f4de9a3")
                .shelterName("보호소 이름입니다.")
                .shelterAddress("보호소 주소입니다.")
                .shelterPhoneNumber("보호소 전화번호입니다.")
                .status(ShelterStatus.UNDER_REVIEW)
                .certificateImages(List.of(image2, image3))
                .build();

        mattermostService.sendMetaMostMessage(shelter);
    }

    @PostMapping("/fundraiser/test")
    @ApiOperation(value = "보호소 권한 테스트", notes = "")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(조회 성공)"),
            @ApiResponse(code = 500, message = "서버 오류")
    })
    public void shelterTest(){
        log.info("왔어요");
    }
}
