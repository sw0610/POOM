package com.poom.backend.api.service.donation;

import com.poom.backend.api.dto.donation.DonationRes;

public interface DonationService {
    DonationRes getMyDonationList(int size, int page);
}
