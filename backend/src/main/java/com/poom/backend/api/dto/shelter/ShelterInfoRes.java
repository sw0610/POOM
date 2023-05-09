package com.poom.backend.api.dto.shelter;

import com.poom.backend.db.entity.Shelter;
import com.poom.backend.enums.ShelterStatus;
import lombok.*;

import java.time.LocalDate;
import java.util.Optional;

@Setter
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ShelterInfoRes {
    private String shelterId;
    private String shelterName;
    private String shelterAddress;
    private String shelterPhoneNumber;
    private ShelterStatus shelterStatus;
    private LocalDate regDate;

    public static ShelterInfoRes of(Shelter shelter) {
        return ShelterInfoRes.builder()
                .shelterId(shelter.getId())
                .shelterName(shelter.getShelterName())
                .shelterAddress(shelter.getShelterAddress())
                .shelterPhoneNumber(shelter.getShelterPhoneNumber())
                .shelterStatus(shelter.getStatus())
                .regDate(shelter.getRegDate())
                .build();
    }
}
