package com.poom.backend.api.service.fundraiser;

import com.poom.backend.api.dto.fundraiser.*;
import com.poom.backend.api.service.ipfs.IpfsService;
import com.poom.backend.api.service.member.MemberService;
import com.poom.backend.config.Web3jConfig;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.web3j.poomcontract.PoomContract;
import org.web3j.protocol.core.RemoteFunctionCall;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.math.BigInteger;
import java.util.List;
import java.util.stream.Collectors;



@Service
@RequiredArgsConstructor
public class FundraiserServiceImpl implements FundraiserService{
    private final MemberService memberService;
    private final IpfsService ipfsService;
//    private final PoomContract poomContract;


    @Override
    public MyFundraiserListRes getMyFundraiserList(HttpServletRequest request, int size, int page, boolean isClosed) {
        String memberId = memberService.getMemberIdFromHeader(request);
        String shelterId = null;
        // 스마트 컨트랙트 호출 부분
//        RemoteFunctionCall<List> myFundraiserList = poomContract.getMyFundraiserList(shelterId, isClosed, BigInteger.valueOf(page), BigInteger.valueOf(size));



        return null;
    }

    @Override
    public void createFundraiser(HttpServletRequest request, List<MultipartFile> dogImages, MultipartFile nftImage, MultipartFile mainImage, OpenFundraiserCond openFundraiserCond) {
        String memberId = memberService.getMemberIdFromHeader(request);

        // 이미지들을 IPFS에 저장한다.
        List<String> dogImageHash = dogImages.stream().map(file ->
            ipfsService.uploadImage(file)
        ).collect(Collectors.toList());
        String nftImageHash = ipfsService.uploadImage(nftImage);
        String mainImageHash = ipfsService.uploadImage(mainImage);

        // 후원 모집 JSON을 IPFS에 저장한다.
        String hashString = null;
        try {
            IPFSFundraiserDto ipfsDto = new IPFSFundraiserDto(); // TODO : 이미지 해시, 후원 정보들을 합쳐 저장해야한다.
            hashString = ipfsService.uploadJson(ipfsDto.toJson());
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        // 스마트 컨트랙트에 등록하기 위한 객체 생성
        SmartContractFundraiserDto sc = SmartContractFundraiserDto.from(openFundraiserCond, hashString);

        // 스마트 컨트랙트 호출해 저장한다.


    }

    @Override
    public List<FundraiserDto> getFundraiserList(int size, int page, boolean isClosed) {
        // 스마트 컨트랙트 호출 부분
        try{
//            List<PoomContract.Fundraiser> fundraiserList = poomContract.getFundraiserList(isClosed, BigInteger.valueOf(page), BigInteger.valueOf(size)).send();
        }catch (Exception e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    @Override
    public FundraiserDetailRes getFundraiserDetail(Long fundraiserId) {
        // 스마트 컨트랙트 호출 부분
//        poomContract.getFundraiserDetail(BigInteger.valueOf(fundraiserId));
        return null;
    }
}
