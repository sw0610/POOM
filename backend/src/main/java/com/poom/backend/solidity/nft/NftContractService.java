package com.poom.backend.solidity.nft;

import com.poom.backend.api.dto.nft.SmartContractNftDto;

import java.util.List;

public interface NftContractService {

    List<SmartContractNftDto> getNftList(String memberId) throws Exception;
    void mintNft(String memberId, Long fundraiserId, Long donationId, String metadataUri, String imageUri) throws Exception;


}
