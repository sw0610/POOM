package com.poom.backend.api.dto.donation;

import com.poom.backend.db.entity.Member;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class FundraiserDonationDto {

    private String memberId;
    private String nickname;
    private String profileImgUrl;
    private Double donationAmount;

    // 테스트시 바꿔야함
    public static FundraiserDonationDto toFundraiserDonationDto(SmartContractDonationDto donationDto, Member member) {
        return FundraiserDonationDto.builder()
                .memberId(member.getId())
                .nickname(member.getNickname())
                .profileImgUrl(member.getProfileImgUrl())
                .donationAmount(donationDto.donationAmount)
                .build();
    }

}
