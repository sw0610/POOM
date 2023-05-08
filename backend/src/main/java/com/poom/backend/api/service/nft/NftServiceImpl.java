package com.poom.backend.api.service.nft;

import com.poom.backend.api.dto.nft.NftIssueCond;
import com.poom.backend.api.dto.nft.NftListRes;
import com.poom.backend.api.dto.nft.SmartContractNftDto;
import com.poom.backend.db.repository.MemberRepository;
import com.poom.backend.exception.BadRequestException;
import com.poom.backend.solidity.nft.NftContractService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class NftServiceImpl implements NFTService{

    private static NftContractService nftContractService;
    private static MemberRepository memberRepository;

    @Override
    public NftListRes getNFTList(int size, int page, String memberId) {

        List<SmartContractNftDto> smartContractNftDto = nftContractService.getNftList(memberId)
            .orElseThrow(()->new RuntimeException());

        int startIdx = size*page;
        int endIdx = startIdx + size > smartContractNftDto.size() ? smartContractNftDto.size() : startIdx + size;
        String[] imgUrls = new String[endIdx-startIdx];

        for(int i=startIdx;i<endIdx;i++){
            imgUrls[i-startIdx] = smartContractNftDto.get(i).getImageUrl();
        }

        String nickname = memberRepository.findById(memberId).orElseThrow(()->new BadRequestException("회원 정보가 없습니다."))
            .getNickname();

        NftListRes nftListRes = NftListRes.builder()
            .nickname(nickname)
            .nftCount(smartContractNftDto.size())
            .nftImgUrls(imgUrls)
            .build();

        return nftListRes;
    }

    @Override
    public void nftIssue(NftIssueCond nftIssueCond) {

        // 1.


    }
}
