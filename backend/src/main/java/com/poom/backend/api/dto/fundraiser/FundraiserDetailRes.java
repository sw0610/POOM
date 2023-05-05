package com.poom.backend.api.dto.fundraiser;

import com.poom.backend.api.dto.donation.FundraiserDonationDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class FundraiserDetailRes {

    private String dogName;
    private String shelterId;
    private String shelterAddress;
    private String mainImgUrl;
    private String nftImgUrl;
    private List<String> dogImgUrls;
    private int dogGender;
    private int dogAge;
    private Boolean ageIsEstimated;
    private String dogFeature;
    private Double targetAmount;
    private Double currentAmount;
    private List<FundraiserDonationDto> donations;

}
