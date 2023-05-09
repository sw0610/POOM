// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./FundraiserContract.sol";
import "./DonationContract.sol";
import "./NftContract.sol";

contract PoomContract is FundraiserProcess, DonationProcess, NftProcess{

    /*
        fundraiser
    */
    // 후원 요청 등록
    function createFundraiser(Fundraiser memory _fundraiser) external{
        _createFundraiser(_fundraiser);
    }

    // 모든 후원 요청 목록 조회
    function getFundraiserList() external view returns(Fundraiser[] memory){
        return _getFundraiserList();
    }

    // 후원 요청 상세 조회
    function getFundraiserDetail(uint64 _fundraiserId) external view returns(Fundraiser memory){
        Fundraiser memory fundraiser = _getFundraiserDetail(_fundraiserId);
        return fundraiser;
    }

    // 한 후원에 대한 후원자 목록 조회
    function getDonationList(uint64 _fundraiserId) external view returns(Donation[] memory){
        Donation[] memory donationList = _getDonationList(_fundraiserId);
        return donationList;
    }

    // 후원 요청 종료
    function endFundraiser(uint64 _fundraiserId) external{
        _endFundraiser(_fundraiserId); // 종료
        _setNftFundraiserEnded(_fundraiserId); // isIssued 1로 변경
    }



    /*
        Donation
    */
    // 나의 후원 목록 조회
    function getMyDonationList(string memory _memberId) external view returns(Donation[] memory){
        Donation[] memory myDonationList = _getMyDonationList(_memberId);
        return myDonationList;
    }
    // 후원
    function donate(uint64 _fundraiserId, string memory _memberId, uint256 _donationTime) external payable{
        _donate(_fundraiserId, _memberId, _donationTime, msg.value);
    }



    /*
        NFT
    */
    // NFT 리스트 조회
    function getNftList(string memory _memberId) external view returns(NFT[] memory){
        return _getNftList(_memberId);
    }

    // 마감된 후원 NFT 발급
    function mintNft(string memory _memberId, uint64 _fundraiserId,  uint64 _donationId, string memory _metadataUri, string memory _imageUrl) external{
        _mintNft(_memberId, _fundraiserId, _donationId, _metadataUri, _imageUrl, msg.sender);
        _setNftIssued(_donationId);
    }

}
