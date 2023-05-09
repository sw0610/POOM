package com.poom.backend.api.service.nft;

import com.poom.backend.api.dto.nft.NftIssueCond;
import com.poom.backend.api.dto.nft.NftListRes;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;

public interface NFTService {
    NftListRes getNFTList(int size, int page, String memberId);
    void nftIssue(HttpServletRequest request, NftIssueCond nftIssueCond);


}
