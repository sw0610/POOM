package com.poom.backend.api.dto.fundraiser;

import com.poom.backend.enums.DogGender;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class OpenFundraiserCond {
//    {
//        "dogName" : String,
//            "endDate" : DateTime,
//            "dogGender" : String,
//            "dogAge" : int,
//        "ageIsEstimated": Boolean
//            - True: 추정
//        "targetAmount" : int,
//        "dogFeature" : Text,
//            "walletAddress" : String,
//    }
    private String shelterEthWalletAddress;
    private String dogName;
    @Builder.Default
    private LocalDateTime startDate = LocalDateTime.now();
    private LocalDate endDate;
    private int dogGender;
    private int dogAge;
    private boolean ageIsEstimated;
    private Double targetAmount;
    private String dogFeature;


}
