package com.poom.backend.api.service.mattermost;

import com.poom.backend.api.dto.shelter.ShelterAuthMMCond;
import com.poom.backend.db.entity.Shelter;
import com.poom.backend.db.repository.MemberRepository;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.*;

@RequiredArgsConstructor
public class MattermostServiceFinalImpl{

    private static final String META_MOST_WEBHOOK_URL = "https://meeting.ssafy.com/hooks/dz3nra3df7yc7gbsuab6n16pme";
    private final MemberRepository memberRepository;

    public void sendMetaMostMessage(Shelter shelter) {
        // 메세지를 만듭니다.
        Map<String, Object> requestBody = getRequestBody(shelter);
        // 메세지를 보냅니다.
        sendMessage(requestBody);
    }

    private Map<String, Object> getRequestBody(Shelter shelter) {
        // 요약 정보 취합
        Map<String, Object> requestBody = new HashMap<>();
        String image2 = "https://www.kukinews.com/data/kuk/image/2023/01/18/kuk202301180113.680x.9.jpg";
        String image3 = "https://ipfs.io/ipfs/QmV637KHwPNyd7YzgSaL5Fdn6rk6AsD1cKFbFm3yYmt7QH";
        String image4 = "https://ipfs.io/ipfs/QmW4vfUA5U8V9Vpr7Nt8NLerpe9rkzq5fJdpk9mqp8fAdx?filename=KakaoTalk_20230509_094951477.jpg";

        Map<String, Object> image_1 = new HashMap<>();
        image_1.put("fallback", "image2");
        image_1.put("image_url", image2);
        Map<String, Object> image_2 = new HashMap<>();
        image_1.put("fallback", "image3");
        image_2.put("image_url", image3);

        requestBody.put("attachments",
                Arrays.asList(new ShelterAuthMMCond(memberRepository.findById(shelter.getAdminId()).get(), shelter),
                        new ShelterAuthMMCond(image2, 0),
                        new ShelterAuthMMCond(image3, 1),
                        new ShelterAuthMMCond(image4, 2),
                        ShelterAuthMMCond.getActions(shelter.getId())));
        return requestBody;
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
