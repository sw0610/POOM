package com.poom.backend.api.dto.shelter;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@Builder
@AllArgsConstructor
public class Content {
    String name;
    String address;

    public Content(){
        this.name = "taebong";
        this.address = "hello";
    }
}
