package com.poom.backend.api.service.donation;

import com.poom.backend.api.dto.donation.*;
import com.poom.backend.api.dto.fundraiser.IPFSFundraiserDto;
import com.poom.backend.api.dto.fundraiser.SmartContractFundraiserDto;
import com.poom.backend.api.service.ipfs.IpfsService;
import com.poom.backend.api.service.member.MemberService;
import com.poom.backend.db.repository.MemberRepository;
import com.poom.backend.exception.BadRequestException;
import com.poom.backend.solidity.donation.DonationContractService;
import com.poom.backend.solidity.fundraiser.FundraiserContractService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class DonationServiceImpl implements DonationService {
    private final MemberService memberService;
    private final DonationContractService donationContractService;
    private final FundraiserContractService fundraiserContractService;
    private final IpfsService ipfsService;
    private final MemberRepository memberRepository;

    @Override
    public DonationRes getMyDonationList(HttpServletRequest request, int size, int page) {
        String memberId = memberService.getMemberIdFromHeader(request);

        // 스마트 컨트랙트 호출 부분 (_getMyDonationList)
        List<SmartContractDonationDto> donationList = donationContractService.getDonationList()
                .stream()
                .flatMap(List::stream)
                .filter(donation -> donation.getMemberId().equals(memberId))
                .sorted(Comparator.comparing(SmartContractDonationDto::getDonationTime).reversed())
                .collect(Collectors.toList());

        int startIdx = size * page;
        int endIdx = startIdx + size > donationList.size() ? donationList.size() : startIdx + size;

        List<DonationDto> donationListDto = new ArrayList<>();

        for (int i = startIdx; i < endIdx; i++) {

            SmartContractDonationDto smartContractDonation = donationList.get(i);
            SmartContractFundraiserDto smartContractFundraiserDto =
                    fundraiserContractService.getFundraiserDetail(smartContractDonation.getFundraiserId())
                            .orElseThrow(() -> new RuntimeException());

            IPFSFundraiserDto ipfsFundraiserDto = null;
            try {
                ipfsFundraiserDto =
                        IPFSFundraiserDto.fromJson(ipfsService.downloadJson(smartContractFundraiserDto.getHashString()));
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            DonationDto donation = DonationDto.builder()
                    .donationId(smartContractDonation.getDonationId())
                    .fundraiserId(smartContractDonation.getFundraiserId())
                    .nftImgUrl(ipfsFundraiserDto.getNftImage())
                    .dogName(ipfsFundraiserDto.getDogName())
                    .donateAmount(smartContractDonation.getDonationAmount())
                    .donateDate(smartContractDonation.getDonationTime().toLocalDate())
                    .isIssued(smartContractDonation.getIsIssued())
                    .build();

            donationListDto.add(donation);
        }

        DonationRes donationRes = DonationRes.builder()
                .hasMore(!(endIdx == donationList.size()))
                .donationList(donationListDto)
                .build();

        return donationRes;
    }

    // 한 후원에 대한 후원자 목록
    @Override
    public List<FundraiserDonationDto> getFundraiserDonationList(Long fundraiserId) {
        List<SmartContractDonationDto> donationList = donationContractService.getDonationList()
                .stream()
                .flatMap(List::stream)
                .filter(donation -> donation.getFundraiserId() == fundraiserId)
                .sorted(Comparator.comparing(SmartContractDonationDto::getDonationAmount).reversed())
                .limit(10)
                .collect(Collectors.toList());


        List<FundraiserDonationDto> fundraiserDonationList = donationList.stream()
                .map(donation ->
                        FundraiserDonationDto.toFundraiserDonationDto(donation,
                                memberRepository.findById(donation.getMemberId()).orElseThrow(() -> new BadRequestException("회원 정보가 없습니다."))
                        ))
                .collect(Collectors.toList());
        ;


        return fundraiserDonationList;
    }

    @Override
    public int getNftIsIssued(Long donationId) {

        SmartContractDonationDto smartContractDonationDto = donationContractService.getDonation(donationId)
                .orElseThrow(() -> new BadRequestException("후원 정보가 없습니다."));

        int isIssued = smartContractDonationDto.getIsIssued();

        return isIssued;
    }

    @Override
    public String setDonationSort(Long fundraiserId) {
        List<SmartContractDonationDto> donationList = donationContractService.getDonationList()
                .stream()
                .flatMap(List::stream)
                .filter(donation -> donation.getFundraiserId() == fundraiserId)
                .sorted(Comparator.comparing(SmartContractDonationDto::getDonationAmount).reversed())
                .collect(Collectors.toList());


        List<String> memberIdSort = donationList.stream().map(donation -> donation.getMemberId())
                .collect(Collectors.toList());

        Map<String, Double> memberDonationAmount = donationList
                .stream()
                .collect(Collectors.toMap(SmartContractDonationDto::getMemberId, SmartContractDonationDto::getDonationAmount));

        DonationSortDto donationSortDto = DonationSortDto.builder()
                .memberIdSort(memberIdSort)
                .memberDonationAmount(memberDonationAmount)
                .build();


        String hashString = null;
        try {

            hashString = ipfsService.uploadJson(donationSortDto.donationSortToJson());
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        donationContractService.setDonationSort(fundraiserId, hashString);
        return hashString;

    }

    // 나의 등수 가져오기
    @Override
    public int getMyRank(Long fundraiserId, String memberId) {
        String hashString = donationContractService.getDonationSort(fundraiserId)
                .orElseThrow(() -> new RuntimeException());

        DonationSortDto donationSortDto = null;
        try {
            donationSortDto = DonationSortDto.fromDonationSortJson(ipfsService.downloadJson(hashString));
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        List<String> memberIdSort = donationSortDto.getMemberIdSort();
        int myRank = memberIdSort.indexOf(memberId) + 1;

        return myRank;

    }

    @Override
    public Double getMyAmount(Long fundraiserId, String memberId) {
        String hashString = donationContractService.getDonationSort(fundraiserId)
                .orElseThrow(() -> new RuntimeException());

        DonationSortDto donationSortDto = null;
        try {
            donationSortDto = DonationSortDto.fromDonationSortJson(ipfsService.downloadJson(hashString));
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        Map<String, Double> memberDonationAmount = donationSortDto.getMemberDonationAmount();
        Double myAmount = memberDonationAmount.get(memberId);

        return myAmount;
    }
}
