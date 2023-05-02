package com.poom.backend.api.dto.member;

import com.poom.backend.db.entity.Member;
import com.poom.backend.db.entity.Shelter;
import com.poom.backend.enums.ShelterStatus;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class UpdateMemberInfoRes {
    private String nickname;
    private String profileImgUrl;

    public static UpdateMemberInfoRes from(Member member){
        return UpdateMemberInfoRes.builder()
                .nickname(member.getNickname())
                .profileImgUrl(member.getProfileImgUrl())
                .build();
    }
}
