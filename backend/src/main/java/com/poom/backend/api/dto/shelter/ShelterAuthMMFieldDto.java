package com.poom.backend.api.dto.shelter;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.poom.backend.db.entity.Member;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ShelterAuthMMFieldDto {

    @JsonProperty("short")
    boolean isShort;
    String title;
    String value;

    static List<ShelterAuthMMFieldDto> getFields(ShelterAuthCond cond, Member member){
        List<ShelterAuthMMFieldDto> list = new ArrayList<>();
        list.add(new ShelterAuthMMFieldDto(true, "memberId", member.getId()));
        list.add(new ShelterAuthMMFieldDto(true, "memberEmail", member.getEmail()));
        list.add(new ShelterAuthMMFieldDto(true, "nickname", member.getNickname()));
        if(cond != null){
            System.out.println(cond.shelterId);
            System.out.println(cond.shelterAddress);
        }else{
            System.out.println("cond is null");
        }
        addFields(cond, list);
        return list;
    }

    public static void addFields(Object obj, List list){
        Class<?> clas = obj.getClass();
        Field[] fields = clas.getDeclaredFields();
        for (Field field : fields) {
            field.setAccessible(true);
            String name = field.getName();
            Object value;
            try {
                value = field.get(obj);
            } catch (IllegalAccessException e) {
                value = null;
            }
            list.add(new ShelterAuthMMFieldDto(true, name, value.toString()));
        }
    }
}
