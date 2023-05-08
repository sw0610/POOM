package com.poom.backend.api.service.shelter;

import com.poom.backend.api.dto.shelter.ShelterAuthCond;
import com.poom.backend.api.dto.shelter.ShelterInfoRes;
import com.poom.backend.api.service.ipfs.IpfsService;
import com.poom.backend.api.service.mattermost.MattermostService;
import com.poom.backend.api.service.member.MemberService;
import com.poom.backend.db.entity.Shelter;
import com.poom.backend.db.repository.ShelterRepository;
import com.poom.backend.exception.BadRequestException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ShelterServiceImpl implements ShelterService{
    private final ShelterRepository shelterRepository;
    private final MemberService memberService;
    private final MattermostService mattermostService;
    private final IpfsService ipfsService;
    
    
    // 쉘터 정보 조회
    @Override
    public ShelterInfoRes getShelterInfo(String shelterId) {
        return ShelterInfoRes.of(shelterRepository.findById(shelterId)
                .orElseThrow(()-> new BadRequestException("등록된 쉘터가 아닙니다.")));
    }

    // 쉘터 인증 요청
    @Override
    public void requestShelterAuth(HttpServletRequest request, List<MultipartFile> certificateImages, ShelterAuthCond shelterAuthCond) {

        // 쉘터 정보를 저장하거나 업데이트하거나 가져옵니다.
        Shelter shelter = getOrCreateShelterInfo(memberService.getMemberIdFromHeader(request),
                certificateImages,
                shelterAuthCond
                );

        // mm에 요청 합니다.
        mattermostService.sendMetaMostMessage(shelter);
    }

    private Shelter getOrCreateShelterInfo(String memberIdFromHeader, List<MultipartFile> certificateImages, ShelterAuthCond shelterAuthCond) {
        return null;
    }

    private Shelter createShelterAuth(String memberId, List<String> certificateImageUrls, ShelterAuthCond shelterAuthCond) {
        return null;
    }

    private List<String> getCertificateImageUrls(List<MultipartFile> certificateImages){
        return certificateImages.stream()
                .map((file)-> ipfsService.uploadImage(file))
                .collect(Collectors.toList());
    }

    @Override
    public void confirm(String shelterId) {

    }

    @Override
    public void reject(String shelterId) {

    }
}
