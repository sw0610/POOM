package com.poom.backend.api.dto.fundraiser;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.time.LocalDate;

public class FundraiserDto {
//    {
//        "fundraiserId": ObjectId
//        "dogName": String
//        "mainImgUrl": String
//        "dogGender": String
//        "nftImgUrl": String
//        "endDate": Date (yy.MM.dd)
//        "currendAmount": Number
//        "targetAmount": Number
//    }, ...

    private String fundraiserId;
    private String dogName;
    private String dogGender;
    private String mainImgUrl;
    private String nftUrl;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yy.MM.dd", timezone = "Asia/Seoul")
    private LocalDate endDate;
    private Double currentAmount;
    private Double targetAmount;



}
