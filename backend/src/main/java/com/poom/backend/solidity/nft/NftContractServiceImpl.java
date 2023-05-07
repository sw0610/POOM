package com.poom.backend.solidity.nft;

import com.poom.backend.api.dto.nft.SmartContractNftDto;
import com.poom.backend.config.Web3jConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.web3j.poomcontract.PoomContract;

import java.math.BigInteger;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class NftContractServiceImpl implements NftContractService{

    private static PoomContract poomContract;
    @Autowired
    private NftContractServiceImpl(Web3jConfig web3jConfig){
        poomContract = web3jConfig.getContractApi();
    }

    @Override
    public List<SmartContractNftDto> getNftList(String memberId) {

        List<SmartContractNftDto> nftList = null;


        try {
            List<PoomContract.NFT> nftContractList = nftContractList = poomContract.getNftList(memberId).send();
            nftList = nftContractList.stream()
                    .map(nft -> SmartContractNftDto.fromNftSmartContract(nft))
                    .collect(Collectors.toList());
        } catch (Exception e) {
            throw new RuntimeException(e.getMessage());
        }


        return nftList;
    }

    @Override
    public void mintNft(String memberId, Long fundraiserId, Long donationId, String metadataUri, String imageUri)  {
        try {
            poomContract.mintNft(memberId, BigInteger.valueOf(fundraiserId), BigInteger.valueOf(donationId), metadataUri, imageUri).send();
        } catch (Exception e) {
            throw new RuntimeException(e.getMessage());
        }
    }
}
