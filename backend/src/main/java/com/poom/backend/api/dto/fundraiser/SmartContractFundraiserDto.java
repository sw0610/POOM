package com.poom.backend.api.dto.fundraiser;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Builder
@Setter
@Getter
public class SmartContractFundraiserDto {
//
//    struct Fundraiser { // 모금
//        string shelterId;
//        address payable shelterAddress;
//        string hashString; // ipfs hash
//        uint256 currentAmount; // 현재 모인 금액
//        uint256 targetAmount;
//        bool isEnded; // 종료 되었는지, default false
//
//        // uint64[] donations;
//        // mapping(string => uint64) donations;
//    }

    private String shelterId;
    private String shelterAddress;
    private String hashString;
    private Long currentAmount;
    private Long targetAmount;
    private boolean isEnded;

    public static SmartContractFundraiserDto from(OpenFundraiserCond cond, String hash) {
        return SmartContractFundraiserDto.builder()
                .shelterId(cond.getShelterId())
                .shelterAddress(cond.getShelterEthWalletAddress())
                .hashString(hash)
                .currentAmount(0L)
                .targetAmount(null) // wei , 클라이언트에서는 Double(ETH)로 받으므로 변환 필요함
                .isEnded(false)
                .build();
    }
}
