package com.poom.backend.solidity.fundraiser;

import com.poom.backend.api.dto.fundraiser.SmartContractFundraiserDto;
import com.poom.backend.config.Web3jConfig;
import com.poom.backend.exception.BadRequestException;
import com.poom.backend.exception.NoContentException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.web3j.poomcontract.PoomContract;

import java.math.BigInteger;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class FundraiserContractServiceImpl implements FundraiserContractService {
    private PoomContract poomContract;

    @Autowired
    private FundraiserContractServiceImpl(Web3jConfig web3jConfig){
        poomContract = web3jConfig.getContractApi();
    }

    // 모금 등록
    @Override
    public void createFundraiser(SmartContractFundraiserDto smartContractFundraiserDto){

        SmartContractFundraiserDto fundraiser = new SmartContractFundraiserDto();

        try {
            poomContract.createFundraiser(fundraiser.toFundraiserContract(smartContractFundraiserDto)).send();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    // 모금 목록
    @Override
    public Optional<List<SmartContractFundraiserDto>> getFundraiserList(){

        List<SmartContractFundraiserDto> fundraiserContractList = null;

        try {
            List<PoomContract.Fundraiser> fundraiserList =  poomContract.getFundraiserList().send();
            fundraiserContractList = fundraiserList.stream()
                .map(fundraiser ->SmartContractFundraiserDto.fromFundraiserContract(fundraiser))
                .sorted(Comparator.comparing(SmartContractFundraiserDto::getStartDate).reversed())
                .collect(Collectors.toList());

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return Optional.ofNullable(fundraiserContractList);
    }

    // 모금 상세
    @Override
    public Optional<SmartContractFundraiserDto> getFundraiserDetail(Long fundraiserId){
        SmartContractFundraiserDto fundraiser = null;
        try {
             fundraiser = SmartContractFundraiserDto.fromFundraiserContract(poomContract.getFundraiserDetail(BigInteger.valueOf(fundraiserId)).send());
             if(fundraiser.getFundraiserId().longValue()!=fundraiserId){
                 throw new BadRequestException("모금 정보가 없습니다.");
             }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return Optional.ofNullable(fundraiser);
    }

    @Override
    public void endFundraiser(Long fundraiserId) {
        try {
            poomContract.endFundraiser(BigInteger.valueOf(fundraiserId)).send();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }



}
