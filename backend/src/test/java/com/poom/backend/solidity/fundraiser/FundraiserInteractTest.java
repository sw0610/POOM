package com.poom.backend.solidity.fundraiser;

import com.poom.backend.api.dto.fundraiser.SmartContractFundraiserDto;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
public class FundraiserInteractTest {

  @Autowired
  private FundraiserContractServiceImpl fundraiserInteract;

  @Test
  void createFundraiserTest(){
    SmartContractFundraiserDto fundraiser = new SmartContractFundraiserDto(0L,"test", "0xDA5DF7C0ff5cC8a7e0313cFE6D8f6f0522ef3918", "testhash", 0.0, 100.0,false);
    fundraiserInteract.createFundraiser(fundraiser);
    SmartContractFundraiserDto fundraiser2 = new SmartContractFundraiserDto(0L,"test2", "0xDA5DF7C0ff5cC8a7e0313cFE6D8f6f0522ef3918", "testhash", 0.0, 100.0,false);
    fundraiserInteract.createFundraiser(fundraiser2);
  }
  @Test
  void getFundraiserListTest(){
    System.out.println("getFundraiserListTest ");
//    System.out.println(fundraiserInteract.getFundraiserList().size());
//    System.out.println(fundraiserInteract.getFundraiserList().get(0).getShelterId());
//    System.out.println(fundraiserInteract.getFundraiserList().get(2).getTargetAmount());
//    System.out.println(fundraiserInteract.getFundraiserList().get(1).getFundraiserId());
//    System.out.println(fundraiserInteract.getFundraiserList().get(1).getShelterAddress());
//    System.out.println(fundraiserInteract.getFundraiserList().get(1).getShelterId());
//    System.out.println(fundraiserInteract.getFundraiserList().get(2).getShelterId());

  }

  @Test
  void getFundraiserDetailTest(){
//    System.out.println(fundraiserInteract.getFundraiserDetail(2L).getShelterId());
  }
}
