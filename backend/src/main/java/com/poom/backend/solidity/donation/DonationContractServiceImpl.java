package com.poom.backend.solidity.donation;

import com.poom.backend.api.dto.donation.SmartContractDonationDto;
import com.poom.backend.config.Web3jConfig;
import com.poom.backend.util.ConvertUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.web3j.poomcontract.PoomContract;

import java.math.BigInteger;
import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class DonationContractServiceImpl implements DonationContractService{

    private PoomContract poomContract;
    @Autowired
    private DonationContractServiceImpl(Web3jConfig web3jConfig){
        poomContract = web3jConfig.getContractApi();
    }

    @Override
    public Optional<List<SmartContractDonationDto>> getDonationList(Long fundraiserId){

        List<SmartContractDonationDto> donationList = null;

        try {
            List<PoomContract.Donation> donationContractList = poomContract.getDonationList(BigInteger.valueOf(fundraiserId)).send();
            donationList = donationContractList.stream()
                    .map(donation -> SmartContractDonationDto.fromDonationContract(donation))
                    .collect(Collectors.toList());
        } catch (Exception e) {
            throw new RuntimeException(e.getMessage());
        }

        return Optional.ofNullable(donationList);
    }

    @Override
    public Optional<List<SmartContractDonationDto>> getMyDonationList(String memberId){

        List<SmartContractDonationDto> myDonationList = null;

        try {
            List<PoomContract.Donation> myDonationContractList = poomContract.getMyDonationList(memberId).send();
            myDonationList
                    = myDonationContractList.stream()
                    .map(donation -> SmartContractDonationDto.fromDonationContract(donation))
                    .sorted(Comparator.comparing(SmartContractDonationDto::getDonationTime).reversed()) // 최신순 정렬
                    .collect(Collectors.toList());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return Optional.ofNullable(myDonationList);
    }

}
