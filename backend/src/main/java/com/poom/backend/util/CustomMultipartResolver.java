package com.poom.backend.util;

import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

public class CustomMultipartResolver extends CommonsMultipartResolver { // 생성한 임시 파일은 더 이상 필요하지 않기 때문에 삭제
    @Override
    public void cleanupMultipart(MultipartHttpServletRequest request) {
        // Do nothing
    }
}
