package com.poom.backend.api.dto.shelter;

import com.poom.backend.db.entity.Member;
import com.poom.backend.db.entity.Shelter;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Setter
@Getter
@Builder
@AllArgsConstructor
public class ShelterAuthMMCond {
    String fallback;
    String color;
    String text;
    List<ShelterAuthMMFieldDto> fields;

    public ShelterAuthMMCond(Member member, Shelter shelter){
        this.fallback = "test";
        this.color = "#FF8000";
        this.text = getTestFromMemberInfo(member);
        this.fields = ShelterAuthMMFieldDto.getFields(ShelterAuthCond.from(shelter), member);
    }

    public ShelterAuthMMCond(Member member, ShelterAuthCond cond){
        this.fallback = "test";
        this.color = "#FF8000";
//        this.title = "보호소 등록 신청 도착";
        this.text = getTestFromMemberInfo(member);
        this.fields = ShelterAuthMMFieldDto.getFields(cond, member);
    }

    public String getTestFromMemberInfo(Member member){
        StringBuilder sb = new StringBuilder();
        sb.append("# 보호소 등록 심사 요청이 등록되었습니다. \n");
        sb.append("> **");
        sb.append(member.getNickname());
        sb.append("**");
        sb.append("님이 보호소 등록을 요청하셨습니다. \n\n\n ");
        sb.append("### 심사 요청 요청 정보 \n");
        return sb.toString();
    }
}
