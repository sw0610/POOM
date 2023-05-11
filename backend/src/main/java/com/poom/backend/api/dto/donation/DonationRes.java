package com.poom.backend.api.dto.donation;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DonationRes {
    private boolean hasMore;
    private List<DonationDto> donationList;

}
