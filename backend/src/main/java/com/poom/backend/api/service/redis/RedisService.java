package com.poom.backend.api.service.redis;

public interface RedisService {
    void saveRefreshToken(String memberId, String refreshToken);
    String getRefreshToken(String memberId);
    void removeRefreshToken(String memberId);
}
