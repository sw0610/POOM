package com.poom.backend.db.entity;

import com.poom.backend.enums.Role;
import lombok.*;
import nonapi.io.github.classgraph.json.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

//import javax.persistence.ElementCollection;
//import javax.persistence.EnumType;
//import javax.persistence.Enumerated;
//import javax.persistence.FetchType;
import java.util.List;

@Document(collection = "members")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Member {
    @Id //mongodb에서는 자동으로 생성됨
    private String id;

    private String nickname;

    @Field("profile_img_url")
    private String profileImgUrl;

    private String email;

    private List<Role> roles;

    private boolean isWithdrawal;
}
