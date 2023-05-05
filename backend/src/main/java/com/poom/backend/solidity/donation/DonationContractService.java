package com.poom.backend.solidity.donation;

import com.poom.backend.api.dto.donation.SmartContractDonationDto;

import java.time.LocalDateTime;
import java.util.List;

public interface DonationContractService {


    List<SmartContractDonationDto> getDonationList(Long fundraiserId) throws Exception; // 한 후원에 대한 후원자 목록 조회
    List<SmartContractDonationDto> getMyDonationList(String memberId) throws Exception; // 내 후원 목록 조회

}
