package com.poom.backend.api.service.fundraiser;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
public class fundraiserTest {

  @Autowired
  private FundraiserService fundraiserService;

  @Test
  void getFundriaserListTest(){
    System.out.println("getFundriaserListTest");
    System.out.println(fundraiserService.getFundraiserList(4,0,false));
  }


}
