package com.poom.backend.api.service.shelter;

import com.poom.backend.api.dto.shelter.ShelterAuthCond;
import com.poom.backend.api.dto.shelter.ShelterInfoRes;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Service
public class ShelterServiceImpl implements ShelterService{

    @Override
    public ShelterInfoRes getShelterInfo(String shelterId) {
        return null;
    }

    @Override
    public void createShelterAuth(List<MultipartFile> certificateImages, ShelterAuthCond shelterAuthCond) {

    }

    @Override
    public void confirm(String shelterId) {

    }

    @Override
    public void reject(String shelterId) {

    }
}
