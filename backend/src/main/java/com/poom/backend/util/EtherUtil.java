package com.poom.backend.util;

import java.math.BigDecimal;
import java.math.BigInteger;

public class EtherUtil {

  public static BigInteger etherToWei(Double amount){
    return new BigDecimal(amount).divide(BigDecimal.TEN.pow(18)).toBigInteger();
  }

  public static Double weiToEther(BigInteger amount){
    return amount.doubleValue() / Math.pow(10, 18);
  }

}
