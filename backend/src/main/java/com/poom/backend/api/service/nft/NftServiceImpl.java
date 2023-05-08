package com.poom.backend.api.service.nft;

import com.poom.backend.api.dto.fundraiser.FundraiserDetailRes;
import com.poom.backend.api.dto.fundraiser.SmartContractFundraiserDto;
import com.poom.backend.api.dto.nft.NftIssueCond;
import com.poom.backend.api.dto.nft.NftListRes;
import com.poom.backend.api.dto.nft.NftMetadata;
import com.poom.backend.api.dto.nft.SmartContractNftDto;
import com.poom.backend.api.service.donation.DonationService;
import com.poom.backend.api.service.fundraiser.FundraiserService;
import com.poom.backend.api.service.ipfs.IpfsService;
import com.poom.backend.api.service.member.MemberService;
import com.poom.backend.config.jwt.JwtFilter;
import com.poom.backend.db.entity.Member;
import com.poom.backend.db.repository.MemberRepository;
import com.poom.backend.exception.BadRequestException;
import com.poom.backend.solidity.donation.DonationContractService;
import com.poom.backend.solidity.nft.NftContractService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.web3j.crypto.ECDSASignature;
import org.web3j.crypto.Hash;
import org.web3j.crypto.Keys;
import org.web3j.crypto.Sign;
import org.web3j.utils.Numeric;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.swing.text.html.Option;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.math.BigInteger;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class NftServiceImpl implements NFTService{

    private final NftContractService nftContractService;
    private final MemberRepository memberRepository;
    private final MemberService memberService;
    private final FundraiserService fundraiserService;
    private final DonationContractService donationContractService;
    private final DonationService donationService;
    private final IpfsService ipfsService;


    @Override
    public NftListRes getNFTList(int size, int page, String memberId) {

        List<SmartContractNftDto> smartContractNftDto = nftContractService.getNftList(memberId)
            .orElseThrow(()->new RuntimeException());

        int startIdx = size*page;
        int endIdx = startIdx + size > smartContractNftDto.size() ? smartContractNftDto.size() : startIdx + size;
        String[] imgUrls = new String[endIdx-startIdx];

        for(int i=startIdx;i<endIdx;i++){
            imgUrls[i-startIdx] = smartContractNftDto.get(i).getImageUrl();
        }

        String nickname = memberRepository.findById(memberId).orElseThrow(()->new BadRequestException("회원 정보가 없습니다."))
            .getNickname();

        NftListRes nftListRes = NftListRes.builder()
            .nickname(nickname)
            .nftCount(smartContractNftDto.size())
            .nftImgUrls(imgUrls)
            .build();

        return nftListRes;
    }

    @Override
    public void nftIssue(HttpServletRequest request, NftIssueCond nftIssueCond) {

        Long fundraiserId = nftIssueCond.getFundraiserId();
        String memberId = memberService.getMemberIdFromHeader(request);
        Optional<Member> member = memberRepository.findById(memberId);

        FundraiserDetailRes fundraiserDto = fundraiserService.getFundraiserDetail(fundraiserId);

        // 종료 되었고 해시 있는지 체크하기
        if(fundraiserDto.getIsClosed()==true){
            String hashString = donationContractService.getDonationSort(fundraiserId)
                    .orElseThrow(()->new RuntimeException());
            if (hashString == "") { // 없으면
                hashString = donationService.setDonationSort(fundraiserId); // 생성하기
            }


            int myRank = donationService.getMyRank(fundraiserId, hashString); // 내 등수 가져오기

            MultipartFile nftImageFile = ipfsService.downloadImage(fundraiserDto.getNftImgUrl());// 이미지 url->multipart file

            // 이미지 파일 읽기
            BufferedImage originalImage = null;
            try {
                originalImage = ImageIO.read(nftImageFile.getInputStream());
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

            // 글자 쓰기
            Graphics2D graphics = originalImage.createGraphics();
            graphics.setColor(Color.GREEN);
            graphics.setFont(new Font("Malgun Gothic", Font.BOLD, 30));
            graphics.drawString("#" + myRank, 10, 30);

            // 이미지 파일 저장
//            ByteArrayOutputStream baos = new ByteArrayOutputStream();
//            ImageIO.write(originalImage, "png", baos);

            String myNftImage = "";
            String name = fundraiserDto.getDogName();
            String description = member.get().getNickname() + "님께서 " + name +"에게 ";


            // nft data json 생성
            NftMetadata nftMetadata = NftMetadata.builder()
                    .name()
                    .description()
                    .image()
                    .build();
            
            // 발급 전에 서명 확인
            memberService.verifySignature(nftIssueCond.getMemberAddress(), nftIssueCond.getMemberSignature(), nftIssueCond.getSignMessage());
            // 발급하기





        }


    }



}
