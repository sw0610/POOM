package com.poom.backend.api.service.mattermost;

import com.poom.backend.api.dto.shelter.Content;
import com.poom.backend.api.dto.shelter.ShelterAuthCond;
import com.poom.backend.api.dto.shelter.ShelterAuthMMCond;
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

    private final RestTemplate restTemplate = new RestTemplate();

    @Override
    public void sendMetaMostMessage(Shelter shelter) {
        // 1. 요약 정보를 보냅니다.
        sendSummaryMessage(shelter);

        // 2. 사진들을 보냅니다.
        sendImageMessage(shelter.getCertificateImages());

        // 3. 버튼을 보냅니다.
        sendButtonMessage(shelter.getId());
    }

    private void sendSummaryMessage(Shelter shelter){
        // 요약 정보 취합
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("attachments",
                        List.of(new ShelterAuthMMCond(memberRepository.findById(shelter.getAdminId()).get(), shelter)));
        
        // 전송
        sendMessage(requestBody);
    }

    private void sendImageMessage(List<String> imageUrls){
        StringBuilder attachments = new StringBuilder();
        for (String imageUrl : imageUrls) {
            attachments.append(String.format("{\"image_url\": \"%s\"},", imageUrl));
        }

        // 마지막 쉼표(,) 제거
        if (attachments.length() > 0) {
            attachments.setLength(attachments.length() - 1);
        }
        String payload = String.format("{\"attachments\": [%s]}", attachments.toString());

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<String> request = new HttpEntity<>(payload, headers);
        RestTemplate restTemplate = new RestTemplate();

        restTemplate.postForEntity(META_MOST_WEBHOOK_URL, request, String.class);
    }

    private void sendButtonMessage(String shelterId){
        Map<String, Object> requestBody = new HashMap<>();
        Map<String, Object> attachment = new HashMap<>();
        
        // 승인 버튼
        Map<String, Object> action1 = new HashMap<>();
        action1.put("name", "승인");
        action1.put("integration", createIntegrationBody(shelterId, true));
            
        // 거절 버튼
        Map<String, Object> action2 = new HashMap<>();
        action2.put("name", "거절");
        action2.put("integration", createIntegrationBody(shelterId, false));
        attachment.put("actions", List.of(action1, action2));

        requestBody.put("attachments", List.of(attachment));

        // 전송
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

    private Map<String, Object> createIntegrationBody(String uid, boolean isAgree) {
        Map<String, Object> integration = new HashMap<>();
        String queryParams = "?uid=" + uid + "&isAgree=" + isAgree;
        integration.put("url", "https://k8a805.p.ssafy.io/api/test/button" + queryParams);
        return integration;
    }
}
