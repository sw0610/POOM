package com.poom.backend.db.repository;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.data.mongo.DataMongoTest;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.mongodb.core.MongoTemplate;

import com.poom.backend.db.entity.Member;
import com.poom.backend.enums.Role;
import org.springframework.test.annotation.Rollback;
import org.springframework.transaction.annotation.Transactional;

@DataMongoTest
public class MemberRepositoryTest {

    @Mock
    private MongoTemplate mongoTemplate;

    @Mock
    private MemberRepository memberRepository;

    @Test
    public void testSaveAndGetMember() {
        //given
        Member member = Member.builder()
                .nickname("John2")
                .email("john@test.com")
                .profileImgUrl("https://example.com/profile.png")
                .roles(Arrays.asList(Role.ROLE_USER))
                .build();

        //when
        Member savedMember = memberRepository.save(member);
        Optional<Member> foundMember = memberRepository.findById(savedMember.getId());

        //then
        System.out.println(foundMember.get().getNickname());
        assertThat(foundMember).isPresent();
        assertThat(foundMember.get().getNickname()).isEqualTo(member.getNickname());
    }
}
