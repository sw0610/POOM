package com.poom.backend.api.service.member;

import com.poom.backend.db.entity.Member;
import com.poom.backend.db.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService{
    private final MemberRepository memberRepository;

    @Override
    public Member signUp() {
        return null;
    }
}
