package com.poom.backend.db.repository;

import com.poom.backend.db.entity.Member;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.Optional;

public interface MemberRepository extends MongoRepository<Member, String> {
    Optional<Member> findMemberByEmail(String email);
}
