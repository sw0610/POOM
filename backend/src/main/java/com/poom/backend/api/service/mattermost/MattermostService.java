package com.poom.backend.api.service.mattermost;

import com.poom.backend.api.dto.shelter.Content;
import com.poom.backend.db.entity.Shelter;

import java.util.List;

public interface MattermostService {
    void sendMetaMostMessage(Shelter shelter);
}
