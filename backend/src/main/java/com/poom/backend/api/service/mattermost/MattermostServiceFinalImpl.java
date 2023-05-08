package com.poom.backend.api.service.mattermost;

import com.poom.backend.db.entity.Shelter;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.client.RestTemplate;

import java.util.Collections;
import java.util.Map;

public class MattermostServiceFinalImpl implements MattermostService{

    private static final String META_MOST_WEBHOOK_URL = "https://meeting.ssafy.com/hooks/dz3nra3df7yc7gbsuab6n16pme";
    @Override
    public void sendMetaMostMessage(Shelter shelter) {
        Map<String, Object> requestBody = getRequestBody(shelter);

        sendMessage(requestBody);
    }

    private Map<String, Object> getRequestBody(Shelter shelter) {
        return null;
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
