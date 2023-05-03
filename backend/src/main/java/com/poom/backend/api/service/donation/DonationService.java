package com.poom.backend.api.service.donation;

import com.poom.backend.api.dto.donation.DonationRes;

import javax.servlet.http.HttpServletRequest;

public interface DonationService {
    DonationRes getMyDonationList(HttpServletRequest request, int size, int page);
}
