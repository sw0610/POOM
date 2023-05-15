package com.poom.backend.api.service.redis;

import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.concurrent.TimeUnit;

@RequiredArgsConstructor
@Service
public class RedisServiceImpl implements RedisService{

    private final StringRedisTemplate stringRedisTemplate;

    @Override
    public void saveRefreshToken(String memberId, String refreshToken) {
        ValueOperations<String, String> valueOperations = stringRedisTemplate.opsForValue();
        Duration duration = Duration.ofDays(14);
        valueOperations.set(memberId, refreshToken, duration);
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
