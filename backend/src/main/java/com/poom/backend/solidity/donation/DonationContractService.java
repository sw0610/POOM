package com.poom.backend.solidity.donation;

import com.poom.backend.api.dto.donation.SmartContractDonationDto;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface DonationContractService {


    Optional<List<SmartContractDonationDto>> getDonationList(); // 한 후원에 대한 후원자 목록 조회
    Optional<SmartContractDonationDto> getDonation(Long donationId);
    void setDonationSort(Long fundraiserId, String hashString);
    Optional<String> getDonationSort(Long fundraiserId);

}
