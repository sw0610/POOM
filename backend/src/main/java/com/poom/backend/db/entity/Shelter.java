package com.poom.backend.db.entity;

import com.poom.backend.enums.ShelterStatus;
import lombok.*;
import nonapi.io.github.classgraph.json.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDate;
import java.util.List;

@Document(collection = "shelters")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Shelter {
//        "_id": ObjectId, // 보호소 인증 ID
//            "admin_id": ObjectId, // 보호소 관리자 ID (users collection 참조)
//            "shelter_name": String,
//            "shelter_address": String,
//            "reg_date": Date,
//            "phone_number": String,
//            "status": String, // 인증 신청 상태
//            "documents": [ // 보호소 증명 서류 (사진 파일들)
//    {
//        "_id": ObjectId, // 증명 서류 ID
//            "img_url": String
//    }
//    ]
    @Id
    private String id;

    private String adminId; // memberId

    private String shelterName;

    private String shelterAddress;

    private String shelterPhoneNumber;

    private LocalDate regDate;

    private ShelterStatus status; // 0 : 미인증, 1 : 인증, 2 : 거절, 3 : 심사중

    private List<String> certificateImages;
}
