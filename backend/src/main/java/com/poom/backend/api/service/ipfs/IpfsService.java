package com.poom.backend.api.service.ipfs;

import java.io.IOException;

public interface IpfsService {
    public String saveJsonToIpfs(String json) throws IOException;
}
