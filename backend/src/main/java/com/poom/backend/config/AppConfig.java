package com.poom.backend.config;

import io.ipfs.api.IPFS;
import io.ipfs.multiaddr.MultiAddress;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

@Configuration
public class AppConfig {
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }

    @Bean
    public IPFS ipfs(@Value("${ipfs.api.ipv4}") String ip, @Value("${ipfs.api.port}") String port){
        return new IPFS(new MultiAddress(getUrl(ip,port)));
    }

    public String getUrl(String ip, String port){
        // /ip4/43.201.49.21/tcp/8901
        return "/ip4/"+ip+"/tcp/"+port;
    }
}
