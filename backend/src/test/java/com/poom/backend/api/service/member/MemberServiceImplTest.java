package com.poom.backend.api.service.member;

import com.poom.backend.api.dto.member.SignupCond;
import com.poom.backend.api.service.ipfs.IpfsService;
import com.poom.backend.config.jwt.TokenProvider;
import com.poom.backend.db.entity.Member;
import com.poom.backend.db.repository.MemberRepository;
import com.poom.backend.db.repository.ShelterRepository;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.core.Authentication;

import javax.servlet.http.HttpServletRequest;

import java.util.Optional;

import static org.assertj.core.api.Assertions.*;

@ExtendWith(MockitoExtension.class)
public class MemberServiceImplTest {

    @Mock
    private MemberRepository memberRepository;

    @Mock
    private ShelterRepository shelterRepository;

    @Mock
    private TokenProvider tokenProvider;

    @Mock
    private IpfsService ipfsService;

    @InjectMocks
    private MemberServiceImpl memberService;

    private HttpServletRequest request;

    @BeforeEach
    public void setUp() {
        request = Mockito.mock(HttpServletRequest.class);
    }

    @Test
    public void testSignUp() {
        SignupCond signupCond = new SignupCond("test@example.com");
        Member savedMember = signupCond.toMember();
        Mockito.when(memberRepository.findMemberByEmail(signupCond.getEmail())).thenReturn(Optional.empty());
        Mockito.when(memberRepository.save(Mockito.any(Member.class))).thenReturn(savedMember);

        Member member = memberService.signUp(signupCond);

        assertThat(signupCond.getEmail()).isEqualTo(member.getEmail());
        assertThat(signupCond.getNickname()).isEqualTo(member.getNickname());
    }

    @Test
    public void testGetUserIdFromHeader() {
        String accessToken = "Bearer abc123";
        String memberId = "testuser";
        Authentication authentication = Mockito.mock(Authentication.class);
        Mockito.when(request.getHeader("Authorization")).thenReturn(accessToken);
        Mockito.when(tokenProvider.getAuthentication("abc123")).thenReturn(authentication);
        Mockito.when(authentication.getName()).thenReturn(memberId);

        String result = memberService.getUserIdFromHeader(request);

        System.out.println(result);
        System.out.println(memberId);

        assertThat(memberId).isEqualTo(result);
    }

    @Test
    public void testChangeMemberStatusToWithdrawal() {
        String memberId = "asdfsd1234asa";
        Member member = new SignupCond(memberId).toMember();
        Mockito.when(memberRepository.findById(memberId)).thenReturn(Optional.of(member));

        memberService.changeMemberStatusToWithdrawal(memberId);

        assertThat(member.isWithdrawal()).isTrue();
    }
}