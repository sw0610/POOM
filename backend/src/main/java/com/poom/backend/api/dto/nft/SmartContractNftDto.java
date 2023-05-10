package com.poom.backend.api.dto.nft;

import com.poom.backend.util.ConvertUtil;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.web3j.poomcontract.PoomContract;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SmartContractNftDto {

    private String imageUrl;
    private String metadataUri;
    @Builder.Default
    private LocalDateTime issuedDate = LocalDateTime.now();

    public static SmartContractNftDto fromNftContract(PoomContract.NFT nft){
        return SmartContractNftDto.builder()
            .imageUrl(nft.imageUrl)
            .metadataUri(nft.metadataUri)
            .issuedDate(ConvertUtil.bigIntegerToDateTime(nft.issuedDate))
            .build();
    }

    public PoomContract.NFT toNftContract(SmartContractNftDto nftDto){
        return new PoomContract.NFT(
            nftDto.getImageUrl(),
            nftDto.getMetadataUri(),
            ConvertUtil.dateTimeToBigInteger(nftDto.getIssuedDate())
        );
    }

}
