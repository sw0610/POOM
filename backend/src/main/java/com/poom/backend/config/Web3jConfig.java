package com.poom.backend.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;
import org.web3j.crypto.Credentials;
import org.web3j.crypto.ECKeyPair;
import org.web3j.poomcontract.PoomContract;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.http.HttpService;

import javax.annotation.PostConstruct;
import java.math.BigInteger;

@Component
@Slf4j
public class Web3jConfig {

  @Value("${eth.address}")
  String  masterAddress;
  @Value("${eth.privateKey}")
  String masterPrivateKey;
  @Value("${eth.rpcUtil}")
  String url;
  @Value("${eth.applicationAddress}")
  String contractAddress;
  @Value("${eth.chainId}")
  int chainId;

//  private PoomContract poomContract;

  private Web3j web3j;


//  @PostConstruct
//  public void init() {
//    web3j = createWeb3jApi();
//    poomContract = createContractApi(web3j);
//  }



}
