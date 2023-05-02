package com.poom.backend.api.service.nft;

import com.poom.backend.api.dto.nft.NftIssueCond;
import com.poom.backend.api.dto.nft.NftListRes;
import org.springframework.stereotype.Service;

@Service
public class NftServiceImpl implements NFTService{
    @Override
    public NftListRes getNFTList(int size, int page, String memberId) {
        return null;
    }

    @Override
    public void nftIssue(NftIssueCond nftIssueCond) {

    }
}
