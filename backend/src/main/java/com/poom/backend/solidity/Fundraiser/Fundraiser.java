package com.poom.backend.solidity.Fundraiser;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Fundraiser {
    private String shelterId;
    private String shelterAddress;
    private String hashString; // ipfs hash
    private Long currentAmount; // 현재 모인 금액
    private Long targetAmount;
    private Boolean isEnded; // 종료 되었는지, default false
}
