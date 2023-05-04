package com.poom.backend.solidity.Fundraiser;

import com.poom.backend.api.dto.fundraiser.SmartContractFundraiserDto;
import com.poom.backend.config.Web3jConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.web3j.poomcontract.PoomContract;

import java.math.BigInteger;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Slf4j
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
            poomContract.createFundraiser(fundraiser.toFundraiserSolidity(smartContractFundraiserDto)).send();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    // 모금 목록
    @Override
    public List<SmartContractFundraiserDto> getFundraiserList(){

        List<SmartContractFundraiserDto> fundraiserContractList = null;

        try {
            List<PoomContract.Fundraiser> fundraiserList =  poomContract.getFundraiserList().send();
            fundraiserContractList = fundraiserList.stream()
                .map(fundraiser ->SmartContractFundraiserDto.fromFundraiserSolidity(fundraiser))
                .collect(Collectors.toList());;

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
//        System.out.println(fundraiserList.size());
//        System.out.println(SmartContractFundraiserDto.fromFundraiserSolidity(fundraiserList.get(0)));

        return fundraiserContractList;
    }
    
    // 모금 상세
    @Override
    public SmartContractFundraiserDto getFundraiserDetail(Long fundraiserId){
        SmartContractFundraiserDto fundraiser = null;
        try {
             fundraiser = SmartContractFundraiserDto.fromFundraiserSolidity(poomContract.getFundraiserDetail(BigInteger.valueOf(fundraiserId)).send());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return fundraiser;
    }


}
