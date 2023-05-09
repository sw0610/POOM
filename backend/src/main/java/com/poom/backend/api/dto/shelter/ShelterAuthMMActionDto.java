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

    public static List<ShelterAuthMMActionDto> getActions(String shelterId){
        return List.of(new ShelterAuthMMActionDto(shelterId, true),
                        new ShelterAuthMMActionDto(shelterId, false));
    }

    public ShelterAuthMMActionDto(String shelterId, boolean isApproved){
        this.integration = getIntegration(shelterId, isApproved);
        if(isApproved){
            this.name = "승인";
            return;
        }
        this.name = "거절";
    }


    public static Map<String, Object> getIntegration(String shelterId, boolean isApproved){
        Map<String, Object> integration = new HashMap<>();
        String queryParams = "?shelterId=" + shelterId + "&isApproved=" + isApproved;
        integration.put("url", "https://k8a805.p.ssafy.io/api/test/lop" + queryParams);
        return integration;
    }
}
