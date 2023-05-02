package com.poom.backend.api.dto.member;

import com.fasterxml.jackson.databind.JsonNode;
import com.poom.backend.db.entity.Member;
import com.poom.backend.enums.Role;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class SignupCond {
    private String email;
    private String nickname;
    private String profileImage;

    public SignupCond(String email){
       this.email = email;
       this.nickname = "taebong " + (int)Math.random()*100;
       this.profileImage = "https://ipfs.io/ipfs/QmRbFKaarTaZQ2ReRoEEQSHBe6qdh3R6X9bA3pdweTSWTd";
    }

    public SignupCond(String email, String nickname, String profileImage) {
        this.email = email;
        this.nickname = nickname;
        this.profileImage = profileImage;
    }

    public Member toMember(){
        return Member.builder()
                .nickname(nickname)
                .email(email)
                .profileImgUrl(profileImage)
                .roles(List.of(Role.ROLE_USER))
                .build();
    }
}
