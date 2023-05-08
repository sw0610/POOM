package com.poom.backend.api.dto.member;

import com.poom.backend.db.entity.Member;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@Builder
public class MemberDto {
    Member member;
    String accessToken;
    String refreshToken;

    public static MemberDto from(Member member, String accessToken, String refreshToken){
        return MemberDto.builder()
                .member(member)
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .build();
    }
}
