package com.poom.backend.api.service.oauth;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.poom.backend.api.dto.member.MemberDto;
import com.poom.backend.api.dto.member.SignupCond;
import com.poom.backend.api.service.member.MemberService;
import com.poom.backend.config.jwt.TokenProvider;
import com.poom.backend.db.entity.Member;
import com.poom.backend.db.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

@Service
@Slf4j
@RequiredArgsConstructor
public class OauthServiceImpl implements OauthService {
    private final MemberRepository memberRepository;
    private final MemberService memberService;
    private final TokenProvider tokenProvider;

    @Transactional
    public MemberDto login(String providerName, String code) throws JsonProcessingException {
//        String oauthToken = getTokenResponse(code);
        Member member = getKakaoUserInfo(code);

        // 토큰을 발급합니다.
        String accessToken = tokenProvider.createAccessToken(member);
        String refreshToken = tokenProvider.createRefreshToken(member);

        // redis에 토큰을 저장합니다.

        return MemberDto.from(member, accessToken, refreshToken);
    }

//    public String getTokenResponse(String code) {
//        String access_Token="";
//        String refresh_Token ="";
//        String reqURL = "https://kauth.kakao.com/oauth/token";
//
//        try{
//            URL url = new URL(reqURL);
//            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
//
//            //POST 요청을 위해 기본값이 false인 setDoOutput을 true로
//            conn.setRequestMethod("POST");
//            conn.setDoOutput(true);
//
//            //POST 요청에 필요로 요구하는 파라미터 스트림을 통해 전송
//            BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
//            StringBuilder sb = new StringBuilder();
//            sb.append("grant_type=authorization_code");
//            sb.append("&client_id="+"16f9dc70727d623363f37d2a4e117611"); // TODO REST_API_KEY 입력
//            sb.append("&redirect_uri="+"https://k8a805.p.ssafy.io/api/oauth/kakao"); // TODO 인가코드 받은 redirect_uri 입력
//            sb.append("&code=" + code);
//            bw.write(sb.toString());
//            bw.flush();
//
//            //결과 코드가 200이라면 성공
//            int responseCode = conn.getResponseCode();
//            System.out.println("responseCode : " + responseCode);
//            //요청을 통해 얻은 JSON타입의 Response 메세지 읽어오기
//            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
//            String line = "";
//            String result = "";
//
//            while ((line = br.readLine()) != null) {
//                result += line;
//            }
//            System.out.println("response body : " + result);
//
//            //Gson 라이브러리에 포함된 클래스로 JSON파싱 객체 생성
//            JsonParser parser = new JsonParser();
//            JsonElement element = parser.parse(result);
//
//            access_Token = element.getAsJsonObject().get("access_token").getAsString();
//            refresh_Token = element.getAsJsonObject().get("refresh_token").getAsString();
//
//            System.out.println("access_token : " + access_Token);
//            System.out.println("refresh_token : " + refresh_Token);
//
//            br.close();
//            bw.close();
//        }catch (IOException e) {
//            e.printStackTrace();
//        }
//        return access_Token;
//    }

    private Member getKakaoUserInfo(String accessToken) throws JsonProcessingException {
        // HTTP Header 생성
        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + accessToken);
        headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

        // HTTP 요청 보내기
        HttpEntity<MultiValueMap<String, String>> kakaoUserInfoRequest = new HttpEntity<>(headers);
        RestTemplate rt = new RestTemplate();
        ResponseEntity<String> response = rt.exchange(
                "https://kapi.kakao.com/v2/user/me",
                HttpMethod.POST,
                kakaoUserInfoRequest,
                String.class
        );

        // responseBody에 있는 정보를 꺼냄
        String responseBody = response.getBody();
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode jsonNode = objectMapper.readTree(responseBody);

        log.info(String.valueOf(jsonNode));

        Long id = jsonNode.get("id").asLong();
        String email = jsonNode.get("kakao_account").get("email").asText();
        String nickname = jsonNode.get("properties")
                .get("nickname").asText();
        String profileImage = jsonNode.get("properties")
                .get("profile_image").asText();

        return memberService.signUp(new SignupCond(email, nickname, profileImage));
    }

    public void logout(HttpServletRequest request) {
        //ID로 리프레시토큰을 검색해서 삭제합니다.
    }
}
