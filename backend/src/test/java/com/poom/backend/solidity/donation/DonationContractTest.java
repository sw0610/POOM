package com.poom.backend.solidity.donation;

import com.poom.backend.solidity.fundraiser.FundraiserContractServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
public class DonationContractTest {

    @Autowired
    private FundraiserContractServiceImpl fundraiserInteract;
}
