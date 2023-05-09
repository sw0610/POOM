package com.poom.backend.api.service.redis;

import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Service;

import java.time.Duration;

@RequiredArgsConstructor
@Service
public class RedisServiceImpl implements RedisService{

    private final StringRedisTemplate stringRedisTemplate;

    @Override
    public void saveRefreshToken(String memberId, String refreshToken) {
        ValueOperations<String, String> valueOperations = stringRedisTemplate.opsForValue();
        Duration expireDuration = Duration.ofDays(14); // Expire duration of 2 weeks
        valueOperations.set(memberId, refreshToken, expireDuration);
    }

    @Override
    public String getRefreshToken(String memberId) {
        return stringRedisTemplate.opsForValue().get(memberId);
    }

    @Override
    public void removeRefreshToken(String memberId) {
        stringRedisTemplate.delete(memberId);
    }
}
