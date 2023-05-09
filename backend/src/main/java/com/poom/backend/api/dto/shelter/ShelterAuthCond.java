package com.poom.backend.api.dto.shelter;

import com.poom.backend.db.entity.Shelter;
import com.poom.backend.enums.ShelterStatus;
import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ShelterAuthCond {
//    "shelterId": String
//	"shelterName" : String
//	"shelterAddress" : String
//	"shelterPhoneNumber": String
    String shelterId;
    String shelterName;
    String shelterAddress;
    String shelterPhoneNumber;

    public static ShelterAuthCond from(Shelter shelter) {
        return ShelterAuthCond.builder()
                .shelterId(shelter.getId())
                .shelterName(shelter.getShelterName())
                .shelterAddress(shelter.getShelterAddress())
                .shelterPhoneNumber(shelter.getShelterPhoneNumber())
                .build();
    }

    public Shelter createEntity(String memberId, List urls) {
        return Shelter.builder()
                .shelterName(shelterName)
                .shelterAddress(shelterAddress)
                .shelterPhoneNumber(shelterPhoneNumber)
                .adminId(memberId)
                .status(ShelterStatus.UNDER_REVIEW)
                .certificateImages(urls)
                .build();
    }

    public Shelter updateEntity(Shelter shelter) {
        shelter.setShelterName(shelterName);
        shelter.setShelterAddress(shelterAddress);
        shelter.setShelterPhoneNumber(shelterPhoneNumber);
        return shelter;
    }
}
