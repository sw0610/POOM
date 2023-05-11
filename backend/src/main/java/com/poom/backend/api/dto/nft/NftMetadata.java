package com.poom.backend.api.dto.nft;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.*;

@Builder
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class NftMetadata {
    String description;
    String image;
    String name;


    public String nftMetadataToJson() throws JsonProcessingException { // 객체를 JSON으로 변환합니다.
        ObjectMapper mapper = new ObjectMapper();
        return mapper.writeValueAsString(this);
    }

}
