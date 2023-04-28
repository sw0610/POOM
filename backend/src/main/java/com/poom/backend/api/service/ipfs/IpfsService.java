package com.poom.backend.api.service.ipfs;

import io.ipfs.api.IPFS;
import io.ipfs.api.MerkleNode;
import io.ipfs.api.NamedStreamable;
import io.ipfs.multiaddr.MultiAddress;
import io.ipfs.multihash.Multihash;
import org.springframework.stereotype.Service;

import java.io.IOException;

@Service
public class IpfsService {

    private final IPFS ipfs;

    public IpfsService() {
        ipfs = new IPFS(new MultiAddress("/ip4/43.201.49.21/tcp/8901"));
    }

    public String saveJsonToIpfs(String json) throws IOException {
        NamedStreamable.ByteArrayWrapper byteArrayWrapper = new NamedStreamable.ByteArrayWrapper(json.getBytes());
        MerkleNode node = ipfs.add(byteArrayWrapper).get(0);
        return node.hash.toString();
    }
}

