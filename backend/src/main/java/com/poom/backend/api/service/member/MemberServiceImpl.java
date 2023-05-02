package com.poom.backend.api.service.member;

import com.poom.backend.api.dto.member.SignupCond;
import com.poom.backend.api.dto.member.memberInfoRes;
import com.poom.backend.db.entity.Member;
import com.poom.backend.db.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;

@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService{
    private final MemberRepository memberRepository;

    @Override
    public Member signUp(SignupCond signupCond) {
        Member member = memberRepository.findMemberByEmail(signupCond.getEmail());
        if(member == null){

        }
        return member;
    }

    @Override
    public String getUserIdFromHeader(HttpServletRequest request) {
        String token = request.getHeader("Authrization");
        return null;
    }

    @Override
    public void changeMemberStatus(String id) {

    }

    @Override
    public memberInfoRes getMemberInfo(HttpServletRequest request) {
        return null;
    }

    @Override
    public memberInfoRes updateMemberInfo(HttpServletRequest request, MultipartFile profileImage, String nickname) {
        return null;
    }

}
