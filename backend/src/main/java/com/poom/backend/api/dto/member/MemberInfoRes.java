package com.poom.backend.api.dto.member;

import com.poom.backend.db.entity.Member;
import com.poom.backend.db.entity.Shelter;
import com.poom.backend.enums.ShelterStatus;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MemberInfoRes {
//    "nickname" : String
//	"profileImgUrl": String
//	"email": String
//	"authStatus": int
//		- 0 : 미인증
//		- 1 : 인증
//		- 2 : 거절
//	"shelterId": ObjectId
    private String nickname;
    private String profileImgUrl;
    private String email;
    private ShelterStatus shelterStatus;
    private String shelterId;
    public void setMemberInfo(Member member){
        this.nickname = member.getNickname();
        this.profileImgUrl = member.getProfileImgUrl();
        this.email = member.getEmail();
    }
    public void setShelterInfo(Shelter shelter){
        if(shelter == null) return;
        this.shelterStatus = shelter.getStatus();
        this.shelterId = shelter.getId();
    }
}
