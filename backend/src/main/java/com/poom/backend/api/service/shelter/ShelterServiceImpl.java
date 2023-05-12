package com.poom.backend.api.service.shelter;

import com.poom.backend.api.dto.shelter.ShelterAuthCond;
import com.poom.backend.api.dto.shelter.ShelterInfoRes;
import com.poom.backend.api.service.ipfs.IpfsService;
import com.poom.backend.api.service.mattermost.MattermostService;
import com.poom.backend.api.service.member.MemberService;
import com.poom.backend.db.entity.Member;
import com.poom.backend.db.entity.Shelter;
import com.poom.backend.db.repository.MemberRepository;
import com.poom.backend.db.repository.ShelterRepository;
import com.poom.backend.enums.Role;
import com.poom.backend.enums.ShelterStatus;
import com.poom.backend.exception.BadRequestException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ShelterServiceImpl implements ShelterService{
    private final ShelterRepository shelterRepository;
    private final MemberRepository memberRepository;
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

    @Override
    public void approveShelterAuth(Shelter shelter) {
        // 1. 쉘터의 status를 변경하고 저장합니다.
        shelter.setStatus(ShelterStatus.AUTH);
        shelterRepository.save(shelter);

        // 2. 사용자의 정보를 가져와 ROLE을 추가하고 저장합니다.
        Optional<Member> member = memberRepository.findById(shelter.getAdminId());
        if(member.isEmpty()) {
            mattermostService.sendMessage(" \"ID :"+shelter.getAdminId()+"\"로 검색되는 회원 정보가 없습니다.");
            return;
        }

        Member m = member.get();

        if(m.getRoles().contains(Role.ROLE_SHELTER)){
            mattermostService.sendMessage(" \"ID :"+shelter.getAdminId()+"\"는 이미 보호소 인증 처리된 회원입니다.");
            return;
        }

        m.getRoles().add(Role.ROLE_SHELTER);
        memberRepository.save(m);
        mattermostService.sendColorMessage("승인되었습니다.", "#8fce00");
    }

    @Override
    public void rejectShelterAuth(Shelter shelter) {
        // 1. 쉘터의 status를 변경하고 저장합니다.
        shelter.setStatus(ShelterStatus.REJECT);
        shelterRepository.save(shelter);
        mattermostService.sendColorMessage("거절되었습니다.", "#F6546A");
    }

    private Shelter getOrCreateShelterInfo(String memberId, List<MultipartFile> certificateImages, ShelterAuthCond shelterAuthCond) {
        // 쉘터 정보를 가져옵니다 (없다면 새로 만듭니다)
        Shelter shelter = null;
        if(shelterAuthCond.getShelterId() != null){
            shelter = shelterRepository.findById(shelterAuthCond.getShelterId())
                    .orElseThrow(()-> new BadRequestException("잘못된 보호소 ID입니다."));
            shelter = getOrUpdateShelterInfo(shelter, certificateImages, shelterAuthCond);
        }
        else{
            shelter = shelterAuthCond.createEntity(memberId, getCertificateImageUrls(certificateImages));
            shelter = shelterRepository.save(shelter);
        }
        return shelter;
    }

    private Shelter getOrUpdateShelterInfo(Shelter shelter, List<MultipartFile> certificateImages, ShelterAuthCond shelterAuthCond){
        shelter = shelterAuthCond.updateEntity(shelter);

        if(certificateImages != null) {
             shelter.setCertificateImages(getCertificateImageUrls(certificateImages));
        }
        return shelter;
    }

    private List<String> getCertificateImageUrls(List<MultipartFile> certificateImages){
        return certificateImages.stream()
                .map((file)-> ipfsService.uploadImage(file))
                .collect(Collectors.toList());
    }
}
