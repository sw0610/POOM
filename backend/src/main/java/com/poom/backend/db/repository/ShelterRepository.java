package com.poom.backend.db.repository;

import com.poom.backend.db.entity.Member;
import com.poom.backend.db.entity.Shelter;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.Optional;

public interface ShelterRepository extends MongoRepository<Shelter, String> {
    Optional<Shelter> findShelterByAdminId(String adminId);
}
