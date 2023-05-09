package com.poom.backend.api.dto.fundraiser;

import lombok.*;

import java.util.List;

@AllArgsConstructor
@Getter
public class MyFundraiserListRes {
    private String shelterName;
    private List<FundraiserDto> fundraisers;

}
