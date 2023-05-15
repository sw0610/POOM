package com.poom.backend.api.dto.fundraiser;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.poom.backend.enums.DogGender;
import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
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

    @NotBlank(message = "지갑 주소가 비어있습니다.")
    private String shelterEthWalletAddress;
    @NotNull(message = "강아지 이름이 비어있습니다.")
    private String dogName;
    @Builder.Default
    private LocalDateTime startDate = LocalDateTime.now();
    @NotNull(message = "종료 날짜가 비어있습니다.")
    @JsonFormat(shape= JsonFormat.Shape.STRING, pattern="yyyy-MM-dd HH:mm:ss.SSS")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss.SSS")
    private LocalDateTime endDate;
    @NotNull(message = "강아지 성별이 비어있습니다.")
    private int dogGender;
    @NotNull(message = "강아지 나이가 비어있습니다.")
    private int dogAge;
    private boolean ageIsEstimated;
    @NotNull(message = "목표 금액이 비어있습니다.")
    private Double targetAmount;
    private String dogFeature;


}
