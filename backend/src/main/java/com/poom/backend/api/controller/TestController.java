package com.poom.backend.api.controller;

import com.poom.backend.api.dto.member.LoginRes;
import com.poom.backend.api.dto.member.SignupCond;
import com.poom.backend.api.dto.shelter.ShelterAuthCond;
import com.poom.backend.api.dto.shelter.ShelterAuthMMCond;
import com.poom.backend.api.dto.test.TestDto;
import com.poom.backend.api.service.ipfs.IpfsService;
import com.poom.backend.api.service.mattermost.MattermostService;
import com.poom.backend.api.service.member.MemberService;
import com.poom.backend.api.service.oauth.OauthService;
import com.poom.backend.api.service.shelter.ShelterService;
import com.poom.backend.config.jwt.TokenProvider;
import com.poom.backend.db.entity.Member;
import com.poom.backend.db.entity.Shelter;
import com.poom.backend.db.repository.MemberRepository;
import com.poom.backend.enums.ShelterStatus;
import io.swagger.annotations.*;
import lombok.RequiredArgsConstructor;

import lombok.extern.log4j.Log4j;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.io.IOUtils;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;
import java.util.*;
import java.util.List;

@Api(tags = "테스트 API")
@RestController
@RequiredArgsConstructor
@Slf4j
public class TestController {

    private final MemberService memberService;
    private final IpfsService ipfsService;
    private final ShelterService shelterService;
    private final MattermostService mattermostService;
    private final MemberRepository memberRepository;
    private final TokenProvider tokenProvider;
    private final OauthService oauthService;

    @PostMapping(value = "/test/cond/first", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE, MediaType.APPLICATION_JSON_VALUE})
    @ApiOperation(value = "IMAGE & DTO")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(등록 성공)"),
            @ApiResponse(code = 400, message = "BAD REQUEST(요청 실패)"),
            @ApiResponse(code = 401, message = "UNAUTHORIZED(권한 없음)"),
            @ApiResponse(code = 500, message = "서버에러")
    })
    public ResponseEntity<?> request1Auth(HttpServletRequest request,
                                                @RequestPart("certificateImages") List<MultipartFile> certificateImages,
                                                @RequestPart("cond") ShelterAuthCond shelterAuthCond){
        log.info("이미지 갯수 : {}", certificateImages.size());
        log.info("보호소 이름 : {}", shelterAuthCond.getShelterName());
        return ResponseEntity.status(200).body("성공했나봐요!");
    }

    @PostMapping(value = "/test/cond/second", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE, MediaType.APPLICATION_JSON_VALUE})
    @ApiOperation(value = "IMAGE")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(등록 성공)"),
            @ApiResponse(code = 400, message = "BAD REQUEST(요청 실패)"),
            @ApiResponse(code = 401, message = "UNAUTHORIZED(권한 없음)"),
            @ApiResponse(code = 500, message = "서버에러")
    })
    public ResponseEntity<?> request2Auth(HttpServletRequest request,
                                          @RequestPart("certificateImages") List<MultipartFile> certificateImages){
        log.info("이미지 갯수 : {}", certificateImages.size());
        return ResponseEntity.status(200).body("성공했나봐요!");
    }

    @PostMapping(value = "/test/cond/third", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE, MediaType.APPLICATION_JSON_VALUE})
    @ApiOperation(value = "DTO")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(등록 성공)"),
            @ApiResponse(code = 400, message = "BAD REQUEST(요청 실패)"),
            @ApiResponse(code = 401, message = "UNAUTHORIZED(권한 없음)"),
            @ApiResponse(code = 500, message = "서버에러")
    })
    public ResponseEntity<?> request3Auth(HttpServletRequest request,
                                          @RequestPart("cond") ShelterAuthCond shelterAuthCond){
        log.info("보호소 이름 : {}", shelterAuthCond.getShelterName());
        return ResponseEntity.status(200).body("성공했나봐요!");
    }

    @PostMapping("/test/cond")
    @ApiOperation(value = "Request Part with DTO 테스트", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(등록 성공)"),
            @ApiResponse(code = 400, message = "BAD REQUEST(요청 실패)"),
            @ApiResponse(code = 401, message = "UNAUTHORIZED(권한 없음)"),
            @ApiResponse(code = 500, message = "서버에러")
    })
    public ResponseEntity<?> requestShelterAuth(HttpServletRequest request,
                                                @RequestPart("certificateImages") List<MultipartFile> certificateImages,
                                                @RequestPart("cond") ShelterAuthCond shelterAuthCond){
        return ResponseEntity.status(200).body("hello");
    }


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
        Member member = memberRepository.findById("6448d2f0577f215b3f4de9a3").get();
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
    public ResponseEntity<?> ImageTest(){
        String imageUrl = "https://ipfs.io/ipfs/QmNXpZA7KghqTX757wh54PxfowAWm63ydjhpeiv9WztACV";
        MultipartFile nftImageFile = ipfsService.downloadImage(imageUrl);// 이미지 url->multipart file
        int rank = 901;
//        String url = ipfsService.uploadImage(image);
//        System.out.println(url);
//        MultipartFile nftImageFile = ipfsService.downloadImage(url);

        try {
            BufferedImage originalImage = ImageIO.read(nftImageFile.getInputStream());

            BufferedImage highQualityImage = new BufferedImage(originalImage.getWidth(), originalImage.getHeight(), BufferedImage.TYPE_INT_RGB);
            Graphics2D graphics = highQualityImage.createGraphics();
            graphics.drawImage(originalImage, 0, 0, null);
            graphics.dispose();

            // 글자 쓰기
            graphics = highQualityImage.createGraphics();
            graphics.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);

            // 글자 색상 설정 (배경에 맞게 선택)
            graphics.setColor(Color.WHITE); // 예시로 흰색으로 설정

            // 폰트 로드
            Font customFont = Font.createFont(Font.TRUETYPE_FONT, new File("src/main/resources/fontB.ttf"));
            graphics.setFont(customFont.deriveFont(Font.BOLD, 30));

            // 글자 위치 설정
            int x = 10;
            int y = 30;

            // 배경과 대비되는 테두리 그리기
            graphics.setStroke(new BasicStroke(10)); // 테두리 굵기 설정
            graphics.setColor(new Color(0xFF8E01)); // 테두리 색상 설정
            graphics.drawString("#" + rank, x - 1, y);
            graphics.drawString("#" + rank, x + 1, y);
            graphics.drawString("#" + rank, x, y - 1);
            graphics.drawString("#" + rank, x, y + 1);

            // 실제 글자 그리기
            graphics.setColor(Color.white); // 글자 색상 설정
            graphics.drawString("#" + rank, x, y);

            // 이미지 파일 저장
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(highQualityImage, "jpg", baos);
            byte[] bytes = baos.toByteArray();

            // 파일 이름 및 헤더 설정
            String fileName = nftImageFile.getOriginalFilename();
            String modifiedFileName = "signed_" + fileName;
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.IMAGE_JPEG);
            headers.setContentDispositionFormData("attachment", modifiedFileName);

            // MultipartFile 생성
            ByteArrayInputStream contentStream = new ByteArrayInputStream(bytes);
            FileItem fileItem = new DiskFileItemFactory().createItem(modifiedFileName, MediaType.IMAGE_JPEG_VALUE, true, modifiedFileName);
            try (InputStream in = contentStream; OutputStream out = fileItem.getOutputStream()) {
                IOUtils.copy(in, out);
            } catch (IOException e) {
                throw new IllegalArgumentException("Error copying file", e);
            }
            MultipartFile multipartFile = new CommonsMultipartFile(fileItem);

            // 이미지 업로드
            String hash = ipfsService.uploadImage(multipartFile);

            return ResponseEntity.status(200).body(hash);
        } catch (IOException e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        } catch (FontFormatException e) {
            throw new RuntimeException(e);
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
                .id("123ksadkjsk")
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

    @PostMapping("/test/token/auth/name")
    @ApiOperation(value = "토큰 auth 테스트", notes = "")
    @ApiResponses({
            @ApiResponse(code = 200, message = "OK(조회 성공)"),
            @ApiResponse(code = 500, message = "서버 오류")
    })
    public ResponseEntity<?> tokenAuthTest2(HttpServletRequest request){
        String token = memberService.getToken(request);
        if(oauthService.checkAdmin(token)){
            return ResponseEntity.status(200).body("admin입니다.");
        }
        return ResponseEntity.status(200).body("admin이 아닙니다.");
    }
}
