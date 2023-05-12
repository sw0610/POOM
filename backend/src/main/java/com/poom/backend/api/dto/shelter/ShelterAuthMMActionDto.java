package com.poom.backend.api.dto.shelter;

import lombok.*;
import org.checkerframework.checker.units.qual.A;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ShelterAuthMMActionDto {
    String name;
    Map<String, Object> integration;

    public static List<ShelterAuthMMActionDto> getActions(String shelterId, String token){
        return List.of(new ShelterAuthMMActionDto(shelterId, true, token),
                        new ShelterAuthMMActionDto(shelterId, false, token));
    }

    public ShelterAuthMMActionDto(String shelterId, boolean isApproved, String token){
        this.integration = getIntegration(shelterId, isApproved, token);
        if(isApproved){
            this.name = "승인";
            return;
        }
        this.name = "거절";
    }

    public static Map<String, Object> getIntegration(String shelterId, boolean isApproved, String token){
        Map<String, Object> integration = new HashMap<>();
        String queryParams = "?shelterId=" + shelterId + "&isApproved=" + isApproved + "&token=" + token;
        integration.put("url", "https://k8a805.p.ssafy.io/api/admin/shelter/auth" + queryParams);
        return integration;
    }
}
