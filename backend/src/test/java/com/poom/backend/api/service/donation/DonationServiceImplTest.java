package com.poom.backend.api.service.donation;

import com.poom.backend.api.service.member.MemberService;
import com.poom.backend.api.service.member.MemberServiceImpl;
import com.poom.backend.solidity.donation.DonationContractService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;

import javax.servlet.http.HttpServletRequest;

import static org.assertj.core.api.Assertions.*;

@ExtendWith(MockitoExtension.class)
class DonationServiceImplTest {
    @Mock
    private MemberService memberService;

    @Mock
    private DonationContractService donationContractService;

    @InjectMocks
    private DonationServiceImpl donationService;

    @Mock
    private HttpServletRequest request;

    @BeforeEach
    public void setUp() {
        request = Mockito.mock(HttpServletRequest.class);
    }

    @Test
    public void donationListTest(){

        donationService.getMyDonationList(request,10, 0);

    }



}