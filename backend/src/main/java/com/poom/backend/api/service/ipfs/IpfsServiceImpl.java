package com.poom.backend.api.service.ipfs;

import io.ipfs.api.IPFS;
import io.ipfs.api.MerkleNode;
import io.ipfs.api.NamedStreamable;
import io.ipfs.multiaddr.MultiAddress;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Service
@RequiredArgsConstructor
public class IpfsServiceImpl implements IpfsService{

    private final IPFS ipfs;

    public String uploadJson(String json) throws IOException {
        NamedStreamable.ByteArrayWrapper byteArrayWrapper = new NamedStreamable.ByteArrayWrapper(json.getBytes());
        MerkleNode node = ipfs.add(byteArrayWrapper).get(0);
        return node.hash.toString();
    }

    @Override
    public String downloadJson(String hash) {
        return null;
    }

    @Override
    public String uploadImage(MultipartFile file) {
        return null;
    }

    @Override
    public MultipartFile downloadFile(String hash) {
        return null;
    }
}

