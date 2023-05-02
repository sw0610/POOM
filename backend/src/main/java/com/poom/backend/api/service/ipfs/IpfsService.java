package com.poom.backend.api.service.ipfs;

import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface IpfsService {
    String uploadJson(String json) throws IOException; // NFT의 메타데이터 IPFS에 저장
    String downloadJson(String hash); // NFT의 메타데이터 IPFS에서 가져오기

    String uploadImage(MultipartFile file);
    MultipartFile downloadImage(String hash);
    
}
