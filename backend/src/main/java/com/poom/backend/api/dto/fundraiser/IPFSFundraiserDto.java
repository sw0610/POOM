package com.poom.backend.api.dto.fundraiser;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.poom.backend.enums.DogGender;
import lombok.*;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class IPFSFundraiserDto {
    // IPFS에 저장할 후원 정보를 담는 DTO입니다.
    // TODO IPFS에 무엇을 저장할지 차후 결정


    private String dogName;
    private List<String> dogImage;
    private String nftImage;
    private String mainImage;
    private int dogGender;
    private int dogAge;
    private Boolean ageIsEstimated;
    private String dogFeature;
    private LocalDate endDate;

    public static IPFSFundraiserDto toIPFSFundraiseDto(OpenFundraiserCond openFundraiserCond, List<String> dogImageHash,String nftImageHash, String mainImageHash){
        return IPFSFundraiserDto.builder()
            .dogName(openFundraiserCond.getDogName())
            .dogGender(openFundraiserCond.getDogGender())
            .dogAge(openFundraiserCond.getDogAge())
            .ageIsEstimated(openFundraiserCond.isAgeIsEstimated())
            .dogFeature(openFundraiserCond.getDogFeature())
            .dogImage(dogImageHash)
            .nftImage(nftImageHash)
            .mainImage(mainImageHash)
            .endDate(openFundraiserCond.getEndDate().toLocalDate())
            .build();
    }

    public String toJson() throws JsonProcessingException { // 객체를 JSON으로 변환합니다.
        ObjectMapper mapper = new ObjectMapper();
        return mapper.registerModule(new JavaTimeModule()).writeValueAsString(this); //LocalDate 형 변환이 안돼서 .registerModule(new JavaTimeModule()) 추가
    }

    public static IPFSFundraiserDto fromJson(String json) throws IOException { // JSON을 받아 객체를 리턴합니다.
        ObjectMapper mapper = new ObjectMapper();
        return mapper.registerModule(new JavaTimeModule()).readValue(json, IPFSFundraiserDto.class);//LocalDate 형 변환이 안돼서 .registerModule(new JavaTimeModule()) 추가
    }
}
