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

    @PostMapping("/test/mattermost")
    @ApiOperation(value = "메타모스트 테스트", notes = "<strong>email을 입력받아 테스트를 위한 엑세스 토큰</strong>을 발급합니다.")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(조회 성공)"),
            @ApiResponse(code = 500, message = "서버 오류")
    })
    public ResponseEntity<?> mattermostTest() throws IOException {
        String mattermostWebhookUrl = "https://meeting.ssafy.com/hooks/5zsqqadu1t8npmoptsnsdpc1sa";
        String text = "안태현 똥냄새가 복도에 진동합니다.";
//        String imageUrl = "https://www.kukinews.com/data/kuk/image/2023/01/18/kuk202301180113.680x.9.jpg";
        String image1 = "https://www.kukinews.com/data/kuk/image/2023/01/18/kuk202301180113.680x.9.jpg";
        String image2 = "https://ipfs.io/ipfs/QmV637KHwPNyd7YzgSaL5Fdn6rk6AsD1cKFbFm3yYmt7QH?filename=KakaoTalk_20230421_174005964.jpg";
        String image3 = "https://ipfs.io/ipfs/QmV637KHwPNyd7YzgSaL5Fdn6rk6AsD1cKFbFm3yYmt7QH";
        List<String> imageUrls = List.of(image1, image2, image3);
        String payload = createPayload(imageUrls, text);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<String> request = new HttpEntity<>(payload, headers);
        RestTemplate restTemplate = new RestTemplate();

        ResponseEntity<String> response = restTemplate.postForEntity(mattermostWebhookUrl, request, String.class);

        return null;
    }


    private String createPayload(List<String> imageUrls, String text) {
        StringBuilder attachments = new StringBuilder();
        for (String imageUrl : imageUrls) {
            attachments.append(String.format("{\"image_url\": \"%s\"},", imageUrl));
        }

        // 마지막 쉼표(,) 제거
        if (attachments.length() > 0) {
            attachments.setLength(attachments.length() - 1);
        }

        return String.format("{\"text\": \"%s\", \"attachments\": [%s]}", text, attachments.toString());
    }


    @PostMapping("/test/mattermost2")
    @ApiOperation(value = "메타모스트 테스트2", notes = "<strong>email을 입력받아 테스트를 위한 엑세스 토큰</strong>을 발급합니다.")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(조회 성공)"),
            @ApiResponse(code = 500, message = "서버 오류")
    })
    public void matterMostTest2(){
        String webhookUrl = "https://meeting.ssafy.com/hooks/5zsqqadu1t8npmoptsnsdpc1sa";
        String text = "태봉이가방에 들어가신다";
        String image1 = "https://www.kukinews.com/data/kuk/image/2023/01/18/kuk202301180113.680x.9.jpg";
        String image2 = "https://ipfs.io/ipfs/QmV637KHwPNyd7YzgSaL5Fdn6rk6AsD1cKFbFm3yYmt7QH?filename=KakaoTalk_20230421_174005964.jpg";
        String image3 = "https://ipfs.io/ipfs/QmV637KHwPNyd7YzgSaL5Fdn6rk6AsD1cKFbFm3yYmt7QH";
        List<String> imageUrls = List.of(image1, image2, image3);
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));

        Map<String, Object> attachment = new HashMap<>();
        attachment.put("text", text);
        attachment.put("imageURLs", imageUrls);

        Map<String, Object> action1 = new HashMap<>();
        action1.put("name", "승인");
        action1.put("integration", createIntegrationBody("IOLXADSLL", true));

        Map<String, Object> action2 = new HashMap<>();
        action2.put("name", "거절");
        action2.put("integration", createIntegrationBody("IOLXADSLL", false));

        attachment.put("actions", new Map[]{action1, action2});

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("attachments", new Map[]{attachment});

        HttpEntity<Map<String, Object>> requestEntity =
                new HttpEntity<>(requestBody, headers);

        restTemplate.postForObject(webhookUrl, requestEntity, String.class);
    }

    private Map<String, Object> createIntegrationBody(String uid, boolean isAgree) {
        Map<String, Object> integration = new HashMap<>();
        String queryParams = "?uid=" + uid + "&isAgree=" + isAgree;
        integration.put("url", "https://k8a805.p.ssafy.io/api/test/button" + queryParams);
        return integration;
    }


    @PostMapping("/test/button")
    @ApiOperation(value = "메타모스트 테스트3", notes = "<strong>email을 입력받아 테스트를 위한 엑세스 토큰</strong>을 발급합니다.")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(조회 성공)"),
            @ApiResponse(code = 500, message = "서버 오류")
    })
    public void buttonTest(@RequestParam String uid,
                           @RequestParam boolean isAgree){
        log.info("UID : {}", uid);
        log.info("승인 여부: {}", isAgree);
    }

}
