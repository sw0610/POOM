package com.poom.backend.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;
import org.web3j.crypto.Credentials;
import org.web3j.crypto.ECKeyPair;
import org.web3j.crypto.RawTransaction;
import org.web3j.poomcontract.PoomContract;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.DefaultBlockParameterName;
import org.web3j.protocol.core.methods.request.Transaction;
import org.web3j.protocol.core.methods.response.EthEstimateGas;
import org.web3j.protocol.core.methods.response.EthGasPrice;
import org.web3j.protocol.core.methods.response.EthGetTransactionCount;
import org.web3j.protocol.http.HttpService;
import org.web3j.tx.FastRawTransactionManager;
import org.web3j.tx.RawTransactionManager;
import org.web3j.tx.gas.ContractGasProvider;
import org.web3j.tx.gas.DefaultGasProvider;
import org.web3j.tx.gas.StaticGasProvider;
import org.web3j.tx.response.PollingTransactionReceiptProcessor;
import org.web3j.utils.Convert;

import javax.annotation.PostConstruct;
import java.io.IOException;
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

  private PoomContract poomContract;

  private Web3j web3j;


  @PostConstruct
  public void init() {
    web3j = createWeb3jApi();
    poomContract = loadContract(web3j);
  }

  private Web3j createWeb3jApi(){
    return Web3j.build(new HttpService(url));
  }

  private PoomContract loadContract(Web3j web3j) {
    Credentials credentials = Credentials.create(masterPrivateKey);

    EthGasPrice gasPrice = null;
//    EthGetTransactionCount nonce = null;

    try {
      gasPrice = web3j.ethGasPrice().send();

    } catch (IOException e) {
      throw new RuntimeException(e);
    }
    BigInteger currentGasPrice = gasPrice.getGasPrice();

    // estimate gas limit
//    EthEstimateGas estimateGas = web3j.ethEstimateGas(
//            Transaction.createContractTransaction(
//                    masterAddress, // sender address
//                    nonce, // nonce value
//                    BigInteger.ZERO, // gas price
//                    BigInteger.valueOf(500000), // gas limit
//                    contractAddress
//            )
//    ).send();
//    BigInteger gasGwei = Convert.toWei(String.valueOf(currentGasPrice), Convert.Unit.GWEI).toBigInteger();
    ContractGasProvider contractGasProvider = new StaticGasProvider(currentGasPrice, BigInteger.valueOf(500000));

//    BigInteger gasLimit = estimateGas.getAmountUsed();


    return PoomContract.load(contractAddress, web3j, credentials, contractGasProvider);
  }

}
