package com.poom.backend.api.dto.nft;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;

@Builder
@AllArgsConstructor
@NoArgsConstructor
public class NftMetadata {
    private String name;
    private String description;
    private String image;
    private NftAttributes attributes;


    public String nftMetadataToJson() throws JsonProcessingException { // 객체를 JSON으로 변환합니다.
        ObjectMapper mapper = new ObjectMapper();
        return mapper.writeValueAsString(this);
    }

}
