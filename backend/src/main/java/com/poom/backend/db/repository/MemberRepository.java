package com.poom.backend.db.repository;

import com.poom.backend.db.entity.Member;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface MemberRepository extends MongoRepository<Member, String> {
    Member findMemberByEmail(String email);
}
