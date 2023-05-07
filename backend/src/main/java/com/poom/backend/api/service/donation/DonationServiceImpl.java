package com.poom.backend.api.service.donation;

import com.poom.backend.api.dto.donation.DonationRes;
import com.poom.backend.api.dto.donation.FundraiserDonationDto;
import com.poom.backend.api.dto.donation.SmartContractDonationDto;
import com.poom.backend.api.service.member.MemberService;
import com.poom.backend.db.entity.Member;
import com.poom.backend.db.repository.MemberRepository;
import com.poom.backend.exception.BadRequestException;
import com.poom.backend.solidity.donation.DonationContractService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class DonationServiceImpl implements DonationService {
    private final MemberService memberService;
    private final DonationContractService donationContractService;
    private final MemberRepository memberRepository;

    @Override
    public DonationRes getMyDonationList(HttpServletRequest request, int size, int page) {
        String memberId = memberService.getMemberIdFromHeader(request);
        List<SmartContractDonationDto> donationList = null;

        // 스마트 컨트랙트 호출 부분 (_getMyDonationList)
        try {
            donationList = donationContractService.getMyDonationList(memberId);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        int startIdx = size * page;
        int endIdx = startIdx + size > donationList.size() ? donationList.size() : startIdx + size;

        for (int i = startIdx; i < endIdx; i++){

        }

            return null;
    }

    // 한 후원에 대한 후원자 목록
    @Override
    public List<FundraiserDonationDto> getFundraiserDonationList(Long fundraiserId) {
        List<SmartContractDonationDto> donationList = donationContractService.getDonationList(fundraiserId)
                .orElseThrow(()->new RuntimeException());


        // 최대 10개 반환
        // 어떤 기준으로 정렬 해야하는지??
        List<FundraiserDonationDto> fundraiserDonationList = donationList.stream()
                .limit(10)
//                .flatMap(List::stream)
                .map(donation ->
                        FundraiserDonationDto.toFundraiserDonationDto(donation,
                                memberRepository.findById(donation.getMemberId()).orElseThrow(() -> new BadRequestException("회원 정보가 없습니다."))))
                .collect(Collectors.toList());
        ;

        return fundraiserDonationList;
    }
}
