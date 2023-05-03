package com.poom.backend.api.service.donation;

import com.poom.backend.api.dto.donation.DonationRes;
import com.poom.backend.api.service.member.MemberService;
import com.poom.backend.db.entity.Member;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;

@Service
@RequiredArgsConstructor
public class DonationServiceImpl implements DonationService{
    private final MemberService memberService;

    @Override
    public DonationRes getMyDonationList(HttpServletRequest request, int size, int page) {
        String memberId = memberService.getMemberIdFromHeader(request);
        // 스마트 컨트랙트 호출 부분 (_getMyDonationList)
        return null;
    }
}
