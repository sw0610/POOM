package com.poom.backend.api.service.shelter;

import com.poom.backend.api.dto.shelter.ShelterAuthCond;
import com.poom.backend.api.dto.shelter.ShelterInfoRes;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface ShelterService {
    ShelterInfoRes getShelterInfo(String shelterId);
    void createShelterAuth(List<MultipartFile> certificateImages, ShelterAuthCond shelterAuthCond);
    void confirm(String shelterId);
    void reject(String shelterId);
}
