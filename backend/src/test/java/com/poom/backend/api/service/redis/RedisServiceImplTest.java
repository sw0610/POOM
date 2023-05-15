package com.poom.backend.api.service.redis;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.assertj.core.api.Assertions.*;

@SpringBootTest
class RedisServiceImplTest {

    @Autowired
    public RedisService redisService;

    private String address = "6448d3f63b5986731525d6bc";

    @Test
    public void saveTest(){
        String msg = "hello";
        redisService.saveRefreshToken(address, msg);

        System.out.println(redisService.getRefreshToken("6448d3f63b5986731525d6bc"));
        assertThat(msg).isEqualTo(redisService.getRefreshToken("6448d3f63b5986731525d6bc"));
    }

    @Test
    public void getTest(){
        String address = "64584cc982f977110415a93c";
        String refreshToken = redisService.getRefreshToken(address);

    }

}