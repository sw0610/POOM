package com.poom.backend.api.dto.member;

import com.poom.backend.db.entity.Member;
import com.poom.backend.enums.Role;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class LoginRes {
    String nickname;
    boolean isShelter;

    public static LoginRes from(Member member){
        return LoginRes.builder()
                .nickname(member.getNickname())
                .isShelter(member.getRoles().contains(Role.ROLE_SHELTER) ? true: false)
                .build();
    }
}
