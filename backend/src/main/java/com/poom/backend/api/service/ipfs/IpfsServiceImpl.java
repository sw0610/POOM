package com.poom.backend.api.service.ipfs;

import io.ipfs.api.IPFS;
import io.ipfs.api.MerkleNode;
import io.ipfs.api.NamedStreamable;
import io.ipfs.multiaddr.MultiAddress;
import io.ipfs.multihash.Multihash;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Service
@RequiredArgsConstructor
public class IpfsServiceImpl implements IpfsService{

    private final IPFS ipfs;

    @Value("${ipfs.gateway.dns}")
    private String gateway;

    @Value("${ipfs.gateway.port}")
    private String gatewayPort;

//    public String uploadJson(String json) throws IOException {
//        NamedStreamable.ByteArrayWrapper byteArrayWrapper = new NamedStreamable.ByteArrayWrapper(json.getBytes());
//        MerkleNode node = ipfs.add(byteArrayWrapper).get(0);
//        return node.hash.toString();
//    }

    @Override
    public String uploadJson(String jsonString) throws IOException {
        // JSON 문자열을 IPFS 노드에 저장
        NamedStreamable.ByteArrayWrapper byteArrayWrapper = new NamedStreamable.ByteArrayWrapper(jsonString.getBytes());
        MerkleNode merkleNode = ipfs.add(byteArrayWrapper).get(0);
        Multihash multihash = merkleNode.hash;
        return String.valueOf(multihash);
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
    public MultipartFile downloadImage(String hash) {
        return null;
    }

    public String urlToHash(String url) {
        return url.substring(url.indexOf("ipfs/") + 5);
    }

    public String hashToUrl(String hash){
        return "http://"+gateway+":"+gatewayPort+"/ipfs/"+hash;
    }
}

