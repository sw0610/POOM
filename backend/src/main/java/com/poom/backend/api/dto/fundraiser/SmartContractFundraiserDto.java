package com.poom.backend.api.dto.fundraiser;

import com.poom.backend.util.ConvertUtil;
import lombok.*;
import org.web3j.poomcontract.PoomContract;

import java.math.BigInteger;
import java.time.LocalDateTime;

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
    private LocalDateTime startDate;
    private Double currentAmount;
    private Double targetAmount;
    private Boolean isEnded;
    private String donationSortHash;


    public static SmartContractFundraiserDto from(OpenFundraiserCond cond, String hash, String shelterId) {
        return SmartContractFundraiserDto.builder()
                .shelterId(shelterId)
                .shelterAddress(cond.getShelterEthWalletAddress())
                .hashString(hash)
                .startDate(cond.getStartDate())
                .currentAmount(0.0)
                .targetAmount(cond.getTargetAmount()) // wei , 클라이언트에서는 Double(ETH)로 받으므로 변환 필요함
                .isEnded(false)
                .build();
    }

    // contract -> java
    public static SmartContractFundraiserDto fromFundraiserContract(PoomContract.Fundraiser fundraiser) {

        return SmartContractFundraiserDto.builder()
                .fundraiserId(fundraiser.fundraiserId.longValue())
                .shelterId(fundraiser.shelterId)
                .shelterAddress(fundraiser.shelterAddress)
                .hashString(fundraiser.hashString)
                .startDate(ConvertUtil.bigIntegerToDateTime(fundraiser.startDate))
                .currentAmount(ConvertUtil.weiToEther(fundraiser.currentAmount))
                .targetAmount(ConvertUtil.weiToEther(fundraiser.targetAmount))
                .isEnded(fundraiser.isEnded)
                .donationSortHash(fundraiser.donationSortHash)
                .build();
    }

    // java -> contract
    public PoomContract.Fundraiser toFundraiserContract(SmartContractFundraiserDto smartContractFundraiserDto) {
        return new PoomContract.Fundraiser(
                BigInteger.valueOf(0L),
                smartContractFundraiserDto.getShelterId(),
                smartContractFundraiserDto.getShelterAddress(),
                smartContractFundraiserDto.getHashString(),
                ConvertUtil.dateTimeToBigInteger(smartContractFundraiserDto.getStartDate()),
                ConvertUtil.etherToWei(smartContractFundraiserDto.getCurrentAmount()),
                ConvertUtil.etherToWei(smartContractFundraiserDto.getTargetAmount()),
                smartContractFundraiserDto.getIsEnded(),
                smartContractFundraiserDto.getDonationSortHash()
        );
    }


}
