package com.poom.backend.api.service.mattermost;

import com.poom.backend.api.dto.shelter.Content;
import com.poom.backend.api.dto.shelter.ShelterAuthCond;
import com.poom.backend.api.dto.shelter.ShelterAuthMMCond;
import com.poom.backend.config.jwt.TokenProvider;
import com.poom.backend.db.entity.Member;
import com.poom.backend.db.entity.Shelter;
import com.poom.backend.db.repository.MemberRepository;
import com.poom.backend.db.repository.ShelterRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.*;

@Service
@RequiredArgsConstructor
public class MattermostServiceImpl implements MattermostService{
    private static final String META_MOST_WEBHOOK_URL = "https://meeting.ssafy.com/hooks/dz3nra3df7yc7gbsuab6n16pme";
    private final MemberRepository memberRepository;
    private final TokenProvider tokenProvider;
//    private final RestTemplate restTemplate = new RestTemplate();

    @Override
    public void sendMetaMostMessage(Shelter shelter) {
        // 메세지를 만듭니다.
        Map<String, Object> requestBody = getRequestBody(shelter);
        // 메세지를 보냅니다.
        sendMessage(requestBody);
    }

    private Map<String, Object> getRequestBody(Shelter shelter) {

        Map<String, Object> requestBody = new HashMap<>();

        List<ShelterAuthMMCond> list = new ArrayList<>();
        // 1. 요약 정보
        list.add(new ShelterAuthMMCond(memberRepository.findById(shelter.getAdminId()).get(), shelter));
        // 2. 서류 정보
        addAuthImageUrlsToReq(shelter, list);
        
        // 3.1 버튼에서 사용할 관리자 토큰
        Member admin = memberRepository.findById("6448d2f0577f215b3f4de9a3").get();
        String token = tokenProvider.createRefreshToken(admin);
        
        // 3.2 버튼 정보 생성
        list.add(ShelterAuthMMCond.getActions(shelter.getId(), token));

        requestBody.put("attachments", list);
        return requestBody;
    }

    private static void addAuthImageUrlsToReq(Shelter shelter, List<ShelterAuthMMCond> list) {
        for (int i = 0, size = shelter.getCertificateImages().size(); i < size; i++) {
            list.add(new ShelterAuthMMCond(shelter.getCertificateImages().get(i), i));
        }
    }

    @Override
    public void sendMessage(String msg) {
        // 메세지를 만듭니다.
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("attachments", List.of(ShelterAuthMMCond.getSimpleMsg(msg)));
        // 메세지를 보냅니다.
        sendMessage(requestBody);
    }

    @Override
    public void sendColorMessage(String msg, String color) {
        // 메세지를 만듭니다.
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("attachments", List.of(ShelterAuthMMCond.getColorMsg(msg, color)));
        // 메세지를 보냅니다.
        sendMessage(requestBody);
    }

    private void sendMessage(Map requestBody){
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
        HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(requestBody, headers);
        restTemplate.postForObject(META_MOST_WEBHOOK_URL, requestEntity, String.class);
    }
}
