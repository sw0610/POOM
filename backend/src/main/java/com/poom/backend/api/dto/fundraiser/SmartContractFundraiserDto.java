package com.poom.backend.api.dto.fundraiser;

import com.poom.backend.util.EtherUtil;
import lombok.*;
import org.web3j.poomcontract.PoomContract;

import java.math.BigInteger;
import java.util.List;
import java.util.stream.Collector;

@Builder
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
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
    private Long fundraiserId;
    private String shelterId;
    private String shelterAddress;
    private String hashString;
    private Double currentAmount;
    private Double targetAmount;
    private Boolean isEnded;

    public static SmartContractFundraiserDto from(OpenFundraiserCond cond, String hash) {
        return SmartContractFundraiserDto.builder()
                .shelterId(cond.getShelterId())
                .shelterAddress(cond.getShelterEthWalletAddress())
                .hashString(hash)
                .currentAmount(0.0)
                .targetAmount(cond.getTargetAmount()) // wei , 클라이언트에서는 Double(ETH)로 받으므로 변환 필요함
                .isEnded(false)
                .build();
    }

    // contract -> java
    public static SmartContractFundraiserDto fromFundraiserSolidity(PoomContract.Fundraiser fundraiser){
//
//        return SmartContractFundraiserDto.builder()
//            .shelterId(new String(fundraiser.shelterId))
//            .build();
//        return new SmartContractFundraiserDto(
//            fundraiser.fundraiserId.longValue(),
//            fundraiser.shelterId,
//            fundraiser.shelterAddress,
//            fundraiser.hashString,
//            EtherUtil.weiToEther(fundraiser.currentAmount),
//            EtherUtil.weiToEther(fundraiser.targetAmount),
//            fundraiser.isEnded);
        return SmartContractFundraiserDto.builder()
            .fundraiserId(fundraiser.fundraiserId.longValue())
            .shelterId(fundraiser.shelterId)
            .shelterAddress(fundraiser.shelterAddress)
            .hashString(fundraiser.hashString)
            .currentAmount(EtherUtil.weiToEther(fundraiser.currentAmount))
            .targetAmount(EtherUtil.weiToEther(fundraiser.targetAmount))
            .isEnded(fundraiser.isEnded)
            .build();
    }

    // java -> contract
    public PoomContract.Fundraiser toFundraiserSolidity(SmartContractFundraiserDto smartContractFundraiserDto) {
        return new PoomContract.Fundraiser(
            BigInteger.valueOf(0L),
            smartContractFundraiserDto.getShelterId(),
            smartContractFundraiserDto.getShelterAddress(),
            smartContractFundraiserDto.getHashString(),
            EtherUtil.etherToWei(smartContractFundraiserDto.getCurrentAmount()),
            EtherUtil.etherToWei(smartContractFundraiserDto.getTargetAmount()),
            smartContractFundraiserDto.getIsEnded()
        );}


}
