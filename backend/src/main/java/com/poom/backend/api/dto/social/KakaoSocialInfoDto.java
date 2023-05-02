package com.poom.backend.api.dto.social;

import lombok.*;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class KakaoSocialInfoDto {
    String accountEmail;
    String profileNickname;
    String profileImage;
}
