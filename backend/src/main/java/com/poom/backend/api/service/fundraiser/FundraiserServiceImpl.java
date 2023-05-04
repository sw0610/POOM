package com.poom.backend.api.service.fundraiser;

import com.poom.backend.api.dto.fundraiser.*;
import com.poom.backend.api.service.ipfs.IpfsService;
import com.poom.backend.api.service.member.MemberService;
import com.poom.backend.config.Web3jConfig;
import com.poom.backend.solidity.Fundraiser.FundraiserInteract;
import com.poom.backend.util.EtherUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.web3j.poomcontract.PoomContract;
import org.web3j.protocol.core.RemoteFunctionCall;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;



@Service
@RequiredArgsConstructor
public class FundraiserServiceImpl implements FundraiserService{
    private final MemberService memberService;
    private final IpfsService ipfsService;
    private final FundraiserInteract fundraiserInteract;


    @Override
    public MyFundraiserListRes getMyFundraiserList(HttpServletRequest request, int size, int page, boolean isClosed) {
        String memberId = memberService.getMemberIdFromHeader(request);
        String shelterId = null;

        List<SmartContractFundraiserDto> fundraiserList = fundraiserInteract.getFundraiserList();

        int startIdx = page*size;
        int endIdx = startIdx+size;
        int listLength = endIdx > fundraiserList.size() ? fundraiserList.size() : endIdx;
        int count = 0;
        List<SmartContractFundraiserDto> myFundraiserListRes = new ArrayList<>();

        int listIdx = startIdx;
        while(count<size && listIdx<listLength){
            SmartContractFundraiserDto fundraiser = fundraiserList.get(listIdx);
            if(fundraiser.getIsEnded()==isClosed && fundraiser.getShelterId().equals(shelterId)){
//                myFundraiserListRes.add(fundraiser);


                count++;
            }
            listIdx++;
        }


        // 스마트 컨트랙트 호출 부분
//        RemoteFunctionCall<List> myFundraiserList = poomContract.getMyFundraiserList(shelterId, isClosed, BigInteger.valueOf(page), BigInteger.valueOf(size));

        return null;
    }

    @Override
    public void createFundraiser(HttpServletRequest request, List<MultipartFile> dogImages, MultipartFile nftImage, MultipartFile mainImage, OpenFundraiserCond openFundraiserCond) {
//        String memberId = memberService.getMemberIdFromHeader(request);

        // 이미지들을 IPFS에 저장한다.
        List<String> dogImageHash = dogImages.stream().map(file ->
            ipfsService.uploadImage(file)
        ).collect(Collectors.toList());
        String nftImageHash = ipfsService.uploadImage(nftImage);
        String mainImageHash = ipfsService.uploadImage(mainImage);

        // 후원 모집 JSON을 IPFS에 저장한다.
        String hashString = null;
        try {
            // 이미지 해시, 후원 정보들을 합쳐 저장
            IPFSFundraiserDto ipfsDto = IPFSFundraiserDto.toIPFSFundraiseDto(openFundraiserCond, dogImageHash, nftImageHash, mainImageHash);
            hashString = ipfsService.uploadJson(ipfsDto.toJson());
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        // 스마트 컨트랙트에 등록하기 위한 객체 생성
        SmartContractFundraiserDto sc = SmartContractFundraiserDto.from(openFundraiserCond, hashString);

        // 스마트 컨트랙트 호출해 저장한다.
        fundraiserInteract.createFundraiser(sc);

    }

    @Override
    public List<FundraiserDto> getFundraiserList(int size, int page, boolean isClosed) {
        // 스마트 컨트랙트 호출 부분

        List<SmartContractFundraiserDto> smartContractFundraiserDtoList= fundraiserInteract.getFundraiserList();
        int startIdx = page*size;
        int endIdx = startIdx+size;
        int listLength = endIdx > smartContractFundraiserDtoList.size() ? smartContractFundraiserDtoList.size() : endIdx;
        int count = 0;

        List<FundraiserDto> fundraiserDtoList = new ArrayList<>();

        // IPFS에 저장된 정보들 -> 객체로

        int listIdx = 0;
        while(count<size && listIdx<listLength) {
            SmartContractFundraiserDto smartContractFundraiserDto = smartContractFundraiserDtoList.get(listIdx);
            // IPFS에 저장된 정보들 -> 객체로
            IPFSFundraiserDto ipfsFundraiserDto = null;
            try {
                ipfsFundraiserDto =
                    IPFSFundraiserDto.fromJson(ipfsService.downloadJson(smartContractFundraiserDto.getHashString()));
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            // 이미지 hash -> URL로 변경
            String mainImgUrl = ipfsService.hashToUrl(ipfsFundraiserDto.getMainImage());
            String nftImgUrl = ipfsService.hashToUrl(ipfsFundraiserDto.getNftImage());

            // FundraiserDto에 담기
            FundraiserDto fundraiserDto = FundraiserDto.builder()
                .fundraiserId(smartContractFundraiserDto.getFundraiserId())
                .dogName(ipfsFundraiserDto.getDogName())
                .dogGender(ipfsFundraiserDto.getDogGender().toString())
                .mainImgUrl(mainImgUrl)
                .nftImgUrl(nftImgUrl)
                .endDate(ipfsFundraiserDto.getEndDate())
                .currentAmount(smartContractFundraiserDto.getCurrentAmount())
                .targetAmount(smartContractFundraiserDto.getTargetAmount())
                .build();

            fundraiserDtoList.add(fundraiserDto);

        }


        return fundraiserDtoList;
    }

    @Override
    public FundraiserDetailRes getFundraiserDetail(Long fundraiserId) {
        // 스마트 컨트랙트 호출 부분
//        poomContract.getFundraiserDetail(BigInteger.valueOf(fundraiserId));
        return null;
    }
}
