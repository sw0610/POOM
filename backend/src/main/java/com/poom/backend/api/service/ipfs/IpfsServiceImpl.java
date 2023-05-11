package com.poom.backend.api.service.ipfs;

import com.poom.backend.db.entity.Member;
import com.poom.backend.exception.BadRequestException;
import com.poom.backend.util.ByteArrayMultipartFile;
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
import java.util.List;

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
    public String uploadJson(String jsonString){
        // JSON 문자열을 IPFS 노드에 저장
        NamedStreamable.ByteArrayWrapper byteArrayWrapper = new NamedStreamable.ByteArrayWrapper(jsonString.getBytes());
        MerkleNode merkleNode = null;
        try {
            merkleNode = ipfs.add(byteArrayWrapper).get(0);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        Multihash multihash = merkleNode.hash;
        return multihash.toString();
    }

    @Override
    public String downloadJson(String hash){
        Multihash mh = Multihash.fromBase58(hash);
        // IPFS에서 데이터 가져오기
        byte[] data = new byte[0];
        try {
            data = ipfs.get(mh);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        // 데이터를 문자열로 변환
        String sub = new String(data);
        String result = sub.substring(sub.indexOf("{"), sub.lastIndexOf("}") + 1);
        return result;
    }

    @Override
    public String uploadImage(MultipartFile file){
        NamedStreamable.InputStreamWrapper fileWrapper = null;
        try {
            fileWrapper = new NamedStreamable.InputStreamWrapper(file.getOriginalFilename(), file.getInputStream());
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        // IPFS 네트워크에 파일 업로드
        List<MerkleNode> result = null;
        try {
            result = ipfs.add(fileWrapper);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        if(result.size() == 0) throw new BadRequestException();
        Multihash hash = result.get(0).hash;
        return hashToUrl(hash.toString());
    }

    @Override
    public MultipartFile downloadImage(String url){
        Multihash hash = Multihash.fromBase58(urlToHash(url));
        byte[] fileBytes = new byte[0];
        try {
            fileBytes = ipfs.cat(hash);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        // byte 배열을 MultipartFile로 변환
        return new ByteArrayMultipartFile(fileBytes, hash);
    }

    public String urlToHash(String url) {
        return url.substring(url.indexOf("ipfs/") + 5);
    }
    // https://ipfs.io/ipfs/QmV637KHwPNyd7YzgSaL5Fdn6rk6AsD1cKFbFm3yYmt7QH?filename=KakaoTalk_20230421_174005964.jpg
//    public String hashToUrl(String hash){
//        return "http://"+gateway+":"+gatewayPort+"/ipfs/"+hash;
//    }

    public String hashToUrl(String hash){
        return "https://ipfs.io/ipfs/"+hash;
    }
}

