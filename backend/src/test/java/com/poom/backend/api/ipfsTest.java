package com.poom.backend.api;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.poom.backend.db.entity.Member;
import com.poom.backend.enums.Role;
import com.poom.backend.util.ByteArrayMultipartFile;
import io.ipfs.api.IPFS;
import io.ipfs.api.MerkleNode;
import io.ipfs.api.NamedStreamable;
import io.ipfs.multiaddr.MultiAddress;
import io.ipfs.multihash.Multihash;
import org.json.JSONException;
import org.json.JSONObject;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
public class ipfsTest {
    private static final IPFS ipfs = new IPFS(new MultiAddress("/ip4/43.201.49.21/tcp/8901")).timeout(1000);

    @Test
    public void ipfsConnectionTest() {
        try {
            String version = ipfs.version();
            System.out.println("Connected to IPFS node. Version: " + version);
        } catch (Exception e) {
            System.out.println("Failed to connect to IPFS node.");
        }
    }

    @Test
    public void ipfsJsonTest() throws Exception{
        // 멤버 객체를 JSON 형태로 변환
        ObjectMapper objectMapper = new ObjectMapper();

        //given
        Member member = Member.builder()
                .nickname("John3")
                .email("john@test.com")
                .profileImgUrl("https://example.com/profile.png")
                .roles(Arrays.asList(Role.ROLE_USER))
                .build();

        String jsonString = objectMapper.writeValueAsString(member);

        // JSON 문자열을 IPFS 노드에 저장
        NamedStreamable.ByteArrayWrapper byteArrayWrapper = new NamedStreamable.ByteArrayWrapper(jsonString.getBytes());
        MerkleNode merkleNode = ipfs.add(byteArrayWrapper).get(0);
        Multihash multihash = merkleNode.hash;

        System.out.println(multihash);

        // IPFS에서 데이터 가져오기
        byte[] data = ipfs.get(multihash);

        // 데이터를 문자열로 변환
        String sub = new String(data);

        String result = sub.substring(sub.indexOf("{"), sub.lastIndexOf("}") + 1);


        // JSON 문자열을 파싱하여 JSONObject 객체 생성
        JSONObject json = new JSONObject(result);


        // JSON 문자열을 파싱하여 Member 객체 생성
        Member member2 = objectMapper.readValue(result, Member.class);

        // 닉네임 출력
        System.out.println(member2.getNickname());
    }

    @Test
    public void ipfsFileUploadTest() throws Exception{

        // given
        String filePath = "C:\\ASSAFY\\img\\KakaoTalk_20230310_153652006.jpg";
        MultipartFile file = convertToMultipartFile(filePath);

        // when
        // MultipartFile 객체를 NamedStreamable 객체로 변환
        NamedStreamable.InputStreamWrapper fileWrapper = new NamedStreamable.InputStreamWrapper(file.getOriginalFilename(), file.getInputStream());
        // IPFS 네트워크에 파일 업로드
        List<MerkleNode> result = ipfs.add(fileWrapper);

        if(result.size() == 0) System.out.println("데이터 오류");

        Multihash hash = result.get(0).hash;

        byte[] fileBytes = ipfs.cat(hash);
        // byte 배열을 MultipartFile로 변환
        MultipartFile multipartFile = new ByteArrayMultipartFile(fileBytes, hash);

        //then
        assertThat(multipartFile.getBytes()).isEqualTo(file.getBytes());
//        assertThat(multipartFile.getContentType()).isEqualTo(file.getContentType());
//        assertThat(multipartFile.getOriginalFilename()).isEqualTo(file.getName());
    }

    @Test
    public void imgFileWithMetadataTest(){

    }

    public MultipartFile convertToMultipartFile(String filePath) throws IOException {
        // 파일 경로 생성
        Path path = Paths.get(filePath);
        // 파일 객체 생성
        File file = new File(filePath);
        // 파일을 바이트 배열로 변환
        byte[] fileContent = Files.readAllBytes(path);
        // MultipartFile 객체 생성
        MultipartFile multipartFile = new MockMultipartFile(file.getName(), file.getName(), "image/jpeg", fileContent);
        return multipartFile;
    }
}
