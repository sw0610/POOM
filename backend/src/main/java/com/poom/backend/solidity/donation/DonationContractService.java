package com.poom.backend.solidity.donation;

import com.poom.backend.api.dto.donation.SmartContractDonationDto;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface DonationContractService {


    Optional<List<SmartContractDonationDto>> getDonationList(Long fundraiserId); // 한 후원에 대한 후원자 목록 조회
    Optional<List<SmartContractDonationDto>> getMyDonationList(String memberId); // 내 후원 목록 조회

}
