package com.poom.backend.api.service.nft;

import com.poom.backend.api.dto.nft.NftIssueCond;
import com.poom.backend.api.dto.nft.NftListRes;

public interface NFTService {
    NftListRes getNFTList(int size, int page, String memberId);
    void nftIssue(NftIssueCond nftIssueCond);
}
