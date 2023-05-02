package com.poom.backend.api.service.fundraiser;

import com.poom.backend.api.dto.fundraiser.FundraiserDetailRes;
import com.poom.backend.api.dto.fundraiser.FundraiserDto;
import com.poom.backend.api.dto.fundraiser.MyFundraiserListRes;
import com.poom.backend.api.dto.fundraiser.OpenFundraiserCond;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Service
public class FundraiserServiceImpl implements FundraiserService{
    @Override
    public MyFundraiserListRes getMyFundraiserList(HttpServletRequest request, int size, int page, boolean isClosed) {
        return null;
    }

    @Override
    public void createFundraiser(HttpServletRequest request, List<MultipartFile> dogImages, MultipartFile nftImage, MultipartFile mainImage, OpenFundraiserCond openFundraiserCond) {

    }

    @Override
    public List<FundraiserDto> getFundraiserList(HttpServletRequest request, int size, int page, boolean isClosed) {
        return null;
    }

    @Override
    public FundraiserDetailRes getFundraiserDetail(Long fundraiserId) {
        return null;
    }
}
