package com.poom.backend.db.repository;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.redis.core.StringRedisTemplate;

@SpringBootTest
public class RedisTest {
    @Autowired
    private StringRedisTemplate redisTemplate;
    private final String KEY="keyword";

    @Test
    public void 검색어_저장(){
        //given
        String keyword="한남동 맛집";
        String keyword2="서촌 맛집";

        //when
        redisTemplate.opsForZSet().add(KEY,keyword,1);
        redisTemplate.opsForZSet().incrementScore(KEY,keyword,1);
        redisTemplate.opsForZSet().incrementScore(KEY,keyword,1);

        redisTemplate.opsForZSet().add(KEY,keyword2,1);

        //then
        System.out.println(redisTemplate.opsForZSet().popMax(KEY));
        System.out.println(redisTemplate.opsForZSet().popMin(KEY));

    }
}
