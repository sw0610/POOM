package com.poom.backend.api;

import com.poom.backend.api.service.redis.RedisService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.assertj.core.api.Assertions.*;

@SpringBootTest
public class RedisTest {

    @Autowired
    private RedisService redisService;

    @Test
    public void saveTest(){
        String msg = "hello";
        redisService.saveRefreshToken("6448d3f63b5986731525d6bc", msg);

        System.out.println(redisService.getRefreshToken("6448d3f63b5986731525d6bc"));
        assertThat(msg).isEqualTo(redisService.getRefreshToken("6448d3f63b5986731525d6bc"));
    }
}
