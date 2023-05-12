package com.poom.backend.api.service.nft;

import com.fasterxml.jackson.core.JsonProcessingException;
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
import com.poom.backend.util.ByteArrayMultipartFile;
import lombok.RequiredArgsConstructor;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.io.IOUtils;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.swing.text.html.Option;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;
import java.math.BigInteger;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class NftServiceImpl implements NFTService {

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
                .orElseThrow(() -> new RuntimeException());

        int startIdx = size * page;
        int endIdx = startIdx + size > smartContractNftDto.size() ? smartContractNftDto.size() : startIdx + size;
        String[] imgUrls = new String[endIdx - startIdx];

        for (int i = startIdx; i < endIdx; i++) {

            imgUrls[i - startIdx] = smartContractNftDto.get(i).getImageUrl();
        }

        String nickname = memberRepository.findById(memberId).orElseThrow(() -> new BadRequestException("회원 정보가 없습니다."))
                .getNickname();

        NftListRes nftListRes = NftListRes.builder()
                .hasMore(!(endIdx == smartContractNftDto.size()))
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
        int nftIsIssued = donationService.getNftIsIssued(nftIssueCond.getDonationId());
        if (nftIsIssued == 0) {
            throw new BadRequestException("후원 진행중");
        }
        else if(nftIsIssued == 1){
            throw new BadRequestException("발급 완료된 NFT입니다.");
        }
        // 종료 되었고 후원 순위 해시 있는지 체크하기
        if (fundraiserDto.getIsClosed()) {
            String hashString = donationContractService.getDonationSort(fundraiserId)
                    .orElseThrow(() -> new RuntimeException());

            if (hashString.equals("none")) { // 없으면
                hashString = donationService.setDonationSort(fundraiserId); // 생성하기

            }

            int myRank = donationService.getMyRank(fundraiserId, memberId); // 내 등수 가져오기
            Double myAmount = donationService.getMyAmount(fundraiserId, memberId); // 내 후원 금액 가져오기


            String myNftImageUrl = null; // 이미지 url
            try {
                myNftImageUrl = createNftImage(fundraiserDto.getNftImgUrl(), myRank);
            } catch (IOException | FontFormatException e) {
                throw new RuntimeException(e);
            }
            String dogName = fundraiserDto.getDogName();
            String description = member.get().getNickname() + " 님께서 " + dogName + "에게 "
                    + myAmount + " ETH 후원한 내역에 대한 후원 증서입니다.";


            // nft data json 생성
            NftMetadata nftMetadata = NftMetadata.builder()
                    .name(dogName)
                    .description(description)
                    .image(myNftImageUrl)
                    .build();
            String nftJson = null;
            try {
                nftJson = ipfsService.hashToUrl(ipfsService.uploadJson(nftMetadata.nftMetadataToJson()));
            } catch (JsonProcessingException e) {
                throw new RuntimeException(e);
            }

            // 발급 전에 서명 확인
            boolean verify = memberService.verifySignature(nftIssueCond.getMemberAddress(), nftIssueCond.getMemberSignature(), nftIssueCond.getSignMessage());
            // 발급하기
            if (verify) {
            SmartContractNftDto smartContractNftDto = SmartContractNftDto.builder()
                    .imageUrl(myNftImageUrl)
                    .metadataUri(nftJson)
                    .build();


            nftContractService.mintNft(smartContractNftDto, memberId, nftIssueCond.getMemberAddress(), nftIssueCond.getDonationId(), fundraiserId);
            }

        }


    }


    // nft 이미지 url과 자신의 순위를 받아서 nft 이미지 생성 -> 이미지 url 반환
    public String createNftImage(String imageUrl, int rank) throws IOException, FontFormatException {
        MultipartFile nftImageFile = ipfsService.downloadImage(imageUrl);// 이미지 url->multipart file

            BufferedImage originalImage = ImageIO.read(nftImageFile.getInputStream());

            BufferedImage highQualityImage = new BufferedImage(originalImage.getWidth(), originalImage.getHeight(), BufferedImage.TYPE_INT_RGB);
            Graphics2D graphics = highQualityImage.createGraphics();
            graphics.drawImage(originalImage, 0, 0, null);
            graphics.dispose();

            // 글자 쓰기
            graphics = highQualityImage.createGraphics();
            graphics.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);

            // 글자 색상 설정 (배경에 맞게 선택)
            graphics.setColor(Color.WHITE); // 예시로 흰색으로 설정

            // 폰트 로드
            Font customFont = Font.createFont(Font.TRUETYPE_FONT, new File("src/main/resources/fontB.ttf"));
            graphics.setFont(customFont.deriveFont(Font.BOLD, 30));

            // 글자 위치 설정
            int x = 10;
            int y = 30;

            // 배경과 대비되는 테두리 그리기
            graphics.setStroke(new BasicStroke(10)); // 테두리 굵기 설정
            graphics.setColor(Color.RED); // 테두리 색상 설정
            graphics.drawString("#" + rank, x - 1, y);
            graphics.drawString("#" + rank, x + 1, y);
            graphics.drawString("#" + rank, x, y - 1);
            graphics.drawString("#" + rank, x, y + 1);

            // 실제 글자 그리기
            graphics.setColor(Color.white); // 글자 색상 설정
            graphics.drawString("#" + rank, x, y);

            // 이미지 파일 저장
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(highQualityImage, "jpg", baos);
            byte[] bytes = baos.toByteArray();

            // 파일 이름 및 헤더 설정
            String fileName = nftImageFile.getOriginalFilename();
            String modifiedFileName = "signed_" + fileName;
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.IMAGE_JPEG);
            headers.setContentDispositionFormData("attachment", modifiedFileName);

            // MultipartFile 생성
            ByteArrayInputStream contentStream = new ByteArrayInputStream(bytes);
            FileItem fileItem = new DiskFileItemFactory().createItem(modifiedFileName, MediaType.IMAGE_JPEG_VALUE, true, modifiedFileName);
            try (InputStream in = contentStream; OutputStream out = fileItem.getOutputStream()) {
                IOUtils.copy(in, out);
            } catch (IOException e) {
                throw new IllegalArgumentException("Error copying file", e);
            }
            MultipartFile multipartFile = new CommonsMultipartFile(fileItem);

            // 이미지 업로드
            String hash = ipfsService.uploadImage(multipartFile);


        return hash;

    }


}
