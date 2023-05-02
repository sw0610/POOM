// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./Fundraiser.sol";
import "./Donation.sol";
import "./Nft.sol";

contract PoomContract is FundraiserProcess, DonationProcess, NftProcess{

    /*
        fundraiser
    */
    // 후원 요청 등록
    function createFundraiser(Fundraiser memory _fundraiser) external returns(Fundraiser memory){
        return _createFundraiser(_fundraiser);
    }

    // 모든 후원 요청 목록 조회
    function getFundraiserList(bool _isEnded, uint64 _page, uint64 _size) external view returns(Fundraiser[] memory){
        return _getFundraiserList(_isEnded, _page, _size);
    }

    // 내 후원 요청 목록 조회
    function getMyFundraiserList(string memory _shelterId, bool _isEnded, uint64 _page, uint64 _size) external view returns (Fundraiser[] memory){
        return _getMyFundraiserList(_shelterId, _isEnded, _page, _size);
    }

    // 후원 요청 상세 조회
    function getFundraiserDetail(uint64 _fundraiserId) external view returns(Fundraiser memory, Donation[] memory){
        Fundraiser memory fundraiser = _getFundraiserDetail(_fundraiserId);
        Donation[] memory donationList = _getDonationList(_fundraiserId);
        return (fundraiser, donationList);
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
    function getMyDonationList(string memory _memberId, uint64 _page, uint64 _size) external view returns(Donation[] memory){
        Donation[] memory myDonationList = _getMyDonationList(_memberId, _page, _size);
        return myDonationList;
    }
    // 후원
    function donate(uint64 _fundraiserId, string memory _memberId, string memory _donateDate) external payable returns (uint64){
        return _donate(_fundraiserId, _memberId, _donateDate);
    }


    /*
        NFT
    */
    // NFT 리스트 조회
    function getNftList(string memory _memberId,  uint64 _page, uint64 _size) external view returns(NFT[] memory){
        return _getNftList(_memberId, _page, _size);
    }

    // 마감된 후원 NFT 발급
    function mintNft(string memory _memberId, uint64 _fundraiserId,  uint64 _donationId, string memory _metadataUri, string memory _imageUrl) external{
        _mintNft(_memberId, _fundraiserId, _donationId, _metadataUri, _imageUrl);
        _setNftIssued(_donationId);
    }

}
