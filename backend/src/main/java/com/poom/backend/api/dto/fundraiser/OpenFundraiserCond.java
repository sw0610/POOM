package com.poom.backend.api.dto.fundraiser;

import com.poom.backend.enums.DogGender;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
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
    private String shelterId;
    private String shelterEthWalletAddress;
    private String dogName;
    private LocalDate endDate;
    private DogGender dogGender;
    private int dogAge;
    private boolean ageIsEstimated;
    private Double targetAmount;
    private String dogFeature;
}
