package com.poom.backend.api.dto.nft;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class NftListRes {

  private String nickname;
  private int nftCount;
  private String[] nftImgUrls;

}
