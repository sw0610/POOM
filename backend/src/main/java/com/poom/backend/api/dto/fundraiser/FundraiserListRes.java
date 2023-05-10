package com.poom.backend.api.dto.fundraiser;

import lombok.*;

import java.util.List;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class FundraiserListRes {
    boolean hasMore;
    List<FundraiserDto> fundraiser;
}
