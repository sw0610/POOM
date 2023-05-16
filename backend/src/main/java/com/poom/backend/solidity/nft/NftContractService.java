package com.poom.backend.solidity.nft;

import com.poom.backend.api.dto.nft.SmartContractNftDto;

import java.util.List;
import java.util.Optional;

public interface NftContractService {

    Optional<List<SmartContractNftDto>> getNftList(String memberId);
    Long mintNft(SmartContractNftDto nftDto, String memberId, String memberAddress, Long donationId, Long fundraiserId);


}
