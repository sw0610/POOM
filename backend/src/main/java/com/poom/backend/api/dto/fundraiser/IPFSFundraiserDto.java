package com.poom.backend.api.dto.fundraiser;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;

public class IPFSFundraiserDto {
    // IPFS에 저장할 후원 정보를 담는 DTO입니다.
    // TODO IPFS에 무엇을 저장할지 차후 결정
    private String dogName;

    public String toJson() throws JsonProcessingException { // 객체를 JSON으로 변환합니다.
        ObjectMapper mapper = new ObjectMapper();
        return mapper.writeValueAsString(this);
    }

    public static IPFSFundraiserDto fromJson(String json) throws IOException { // JSON을 받아 객체를 리턴합니다.
        ObjectMapper mapper = new ObjectMapper();
        return mapper.readValue(json, IPFSFundraiserDto.class);
    }
}
