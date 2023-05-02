package com.poom.backend.api.service.member;

import com.poom.backend.db.entity.Member;
import com.poom.backend.db.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;

@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService{
    private final MemberRepository memberRepository;

    @Override
    public Member signUp() {
        return null;
    }

    @Override
    public String getUserIdFromHeader(HttpServletRequest request) {
        String token = request.getHeader("Authrization");
        return null;
    }

}
