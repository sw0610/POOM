package com.poom.backend.api.dto.donation;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class DonationSortDto {
    List<String> memberIdSort;
    Map<String, Double> memberDonationAmount;

    public String donationSortToJson() throws JsonProcessingException { // 객체를 JSON으로 변환합니다.
        ObjectMapper mapper = new ObjectMapper();
        return mapper.writeValueAsString(this);
    }

    public static DonationSortDto fromDonationSortJson(String json) throws IOException { // JSON을 받아 객체를 리턴합니다.
        ObjectMapper mapper = new ObjectMapper();
        return mapper.readValue(json, DonationSortDto.class);//LocalDate 형 변환이 안돼서 .registerModule(new JavaTimeModule()) 추가
    }
}
