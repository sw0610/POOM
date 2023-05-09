package com.poom.backend.api.service.shelter;

import com.poom.backend.api.dto.shelter.ShelterAuthCond;
import com.poom.backend.api.dto.shelter.ShelterInfoRes;
import com.poom.backend.db.entity.Shelter;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public interface ShelterService {
    ShelterInfoRes getShelterInfo(String shelterId);
    public void requestShelterAuth(HttpServletRequest request, List<MultipartFile> certificateImages, ShelterAuthCond shelterAuthCond);
    void approveShelterAuth(Shelter shelter);
    void rejectShelterAuth(Shelter shelter);
}
