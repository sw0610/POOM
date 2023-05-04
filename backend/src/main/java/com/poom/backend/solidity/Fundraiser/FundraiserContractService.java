package com.poom.backend.solidity.Fundraiser;

import com.poom.backend.api.dto.fundraiser.SmartContractFundraiserDto;

import java.util.List;

public interface FundraiserContractService {

    void createFundraiser(SmartContractFundraiserDto smartContractFundraiserDto);
    List<SmartContractFundraiserDto> getFundraiserList();
    SmartContractFundraiserDto getFundraiserDetail(Long fundraiserId);



}
