package com.poom.backend.solidity.nft;

import com.poom.backend.api.dto.nft.SmartContractNftDto;
import com.poom.backend.config.Web3jConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.web3j.poomcontract.PoomContract;

import java.math.BigInteger;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class NftContractServiceImpl implements NftContractService{

    private final PoomContract poomContract;
    @Autowired
    private NftContractServiceImpl(Web3jConfig web3jConfig){
        poomContract = web3jConfig.getContractApi();
    }

    @Override
    public Optional<List<SmartContractNftDto>> getNftList(String memberId) {

        List<SmartContractNftDto> nftList = null;


        try {
            List<PoomContract.NFT> nftContractList = poomContract.getNftList(memberId).send();
            nftList = nftContractList.stream()
                    .map(nft -> SmartContractNftDto.fromNftContract(nft))
                    .sorted(Comparator.comparing(SmartContractNftDto::getIssuedDate).reversed())
                    .collect(Collectors.toList());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }


        return Optional.ofNullable(nftList);
    }

    @Override
    public void mintNft(SmartContractNftDto nftDto, String memberId, String memberAddress, Long donationId, Long fundraiserId)  {
        SmartContractNftDto smartContractNftDto = new SmartContractNftDto();
        try {
            poomContract.mintNft(smartContractNftDto.toNftContract(nftDto), memberId, memberAddress, BigInteger.valueOf(donationId), BigInteger.valueOf(fundraiserId)).send();
        } catch (Exception e) {
            throw new RuntimeException(e.getMessage());
        }
    }
}
