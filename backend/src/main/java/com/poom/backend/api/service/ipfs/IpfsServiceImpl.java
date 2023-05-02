package com.poom.backend.api.service.ipfs;

import io.ipfs.api.IPFS;
import io.ipfs.api.MerkleNode;
import io.ipfs.api.NamedStreamable;
import io.ipfs.multiaddr.MultiAddress;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.io.IOException;

@Service
@RequiredArgsConstructor
public class IpfsServiceImpl implements IpfsService{

    private final IPFS ipfs;

    public String saveJsonToIpfs(String json) throws IOException {
        NamedStreamable.ByteArrayWrapper byteArrayWrapper = new NamedStreamable.ByteArrayWrapper(json.getBytes());
        MerkleNode node = ipfs.add(byteArrayWrapper).get(0);
        return node.hash.toString();
    }
}

