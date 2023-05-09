package com.poom.backend.api.dto.nft;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class NftIssueCond {
  private Long donationId;
  private Long fundraiserId;
  private String memberAddress;
  private String memberSignature;
  private String signMessage;

}
