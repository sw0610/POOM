package com.poom.backend.api.dto.shelter;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.poom.backend.db.entity.Member;
import com.poom.backend.db.entity.Shelter;
import lombok.*;

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
    @JsonProperty("image_url")
    String imageUrl; // add this field
    List<ShelterAuthMMActionDto> actions;

    public static ShelterAuthMMCond getActions(String shelterId){
        ShelterAuthMMCond shelter = new ShelterAuthMMCond();
        shelter.setText("### 승인하시겠습니까?");
        shelter.setActions(ShelterAuthMMActionDto.getActions(shelterId));
        return shelter;
    }

    public static ShelterAuthMMCond getSimpleMsg(String msg){
        ShelterAuthMMCond shelter = new ShelterAuthMMCond();
        shelter.setText("### "+msg);
        return shelter;
    }

    public ShelterAuthMMCond(){
        this.color = "#FF8000";
    }

    public ShelterAuthMMCond(String imageUrl, int idx){
//        this.fallback = "test";
        if(idx == 0){
            this.text = "### 심사 서류 정보 \n";
        }
        this.color = "#FF8000";
        this.imageUrl = imageUrl;
    }

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

    public static ShelterAuthMMCond getColorMsg(String msg, String color) {
        ShelterAuthMMCond cond = new ShelterAuthMMCond();
        cond.setColor(color);
        cond.setText("### "+msg);
        return cond;
    }

    public String getTestFromMemberInfo(Member member){
        StringBuilder sb = new StringBuilder();
        sb.append("# 보호소 등록 심사 요청이 등록되었습니다. \n");
        sb.append("> **");
        sb.append(member.getNickname());
        sb.append("**");
        sb.append("님이 보호소 등록을 요청하셨습니다. \n\n\n ");
        sb.append("### 심사 요청 요약 정보 \n");
        return sb.toString();
    }
}
