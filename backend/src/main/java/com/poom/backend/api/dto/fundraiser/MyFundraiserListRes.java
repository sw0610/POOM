package com.poom.backend.api.dto.fundraiser;

import lombok.*;

import java.util.List;

@AllArgsConstructor
@Getter
@Builder
public class MyFundraiserListRes {
    private String shelterName;
    private boolean hasMore;
    private List<FundraiserDto> fundraisers;

}
