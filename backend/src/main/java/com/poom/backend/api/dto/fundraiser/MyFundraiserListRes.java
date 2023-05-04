package com.poom.backend.api.dto.fundraiser;

import lombok.*;
import org.checkerframework.checker.units.qual.A;

import java.util.List;

@AllArgsConstructor
@Getter
public class MyFundraiserListRes {
    private String shelterName;
    private List<FundraiserDto> fundraisers;

}
