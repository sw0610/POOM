package com.poom.backend.api.dto.nft;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.web3j.poomcontract.PoomContract;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SmartContractNftDto {
    private Long nftId;
    private Long fundraiserId;
    private String memberId;
    private String imageUrl;

    public static SmartContractNftDto fromNftSmartContract(PoomContract.NFT nft){
        return SmartContractNftDto.builder()
                .nftId(nft.nftId.longValue())
                .fundraiserId(nft.fundraiserId.longValue())
                .memberId(nft.memberId)
                .imageUrl(nft.imageUrl)
                .build();
    }
}
