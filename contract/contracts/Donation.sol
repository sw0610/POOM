// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0 <0.9.0;

import "./Fundraiser.sol";

contract DonationContract is FundraiserContract {

    struct Donation { // 후원
        string memberId;
        uint256 donationAmount; // 후원 금액
        uint64 fundraiserId; // 모금 id
        uint256 donationTime; // 모금 시간
        uint16 isIssued; // nft 발급 여부
    }


    uint64 private _donationId;
    mapping(string => uint64[]) public memberDonations; // memberid -> 후원id[]
    // mapping(uint64 => uint256) public myFundraiserCount; // shelterId => my fundraiserCount
    mapping(uint64=>Donation) public donations; //  후원 id -> 후원 내역
    mapping(uint64 => mapping(uint64=>Donation)) public fundraiserDonationList; // 모금 id -> 후원자들
    mapping(uint64 => uint256) public donationsCount; // 모금 id -> 후원자 수

    /*
     후원자 가져오려면
     멤버별 따로 빼기
    */


    // 후원자 목록
    function _getDonationList(uint64 _fundraiserId) internal view returns (Donation[] memory) {
        uint256 donationLength = donationsCount[_fundraiserId];
        Donation[] memory donationList = new Donation[](donationLength);

        for (uint64 i = 0; i < donationLength; i++) {
            donationList[i] = fundraiserDonationList[_fundraiserId][i];
        }

        return donationList;
    }


    // 내 후원 목록 가져오기
    function _getMyDonationList(string memory _memberId, uint64 page, uint64 size) internal view returns(Donation[] memory){

        uint256 myDonationCount = memberDonations[_memberId].length;

        uint64 startIdx = page * size;
        uint64 endIdx = startIdx + size;
        uint256 length = endIdx > myDonationCount ? myDonationCount : endIdx;

        Donation[] memory myDonaionList = new Donation[](myDonationCount);

        for(uint64 i = startIdx; i < length; i++){
            myDonaionList[i-startIdx] = donations[memberDonations[_memberId][i]];
        }
        return myDonaionList;

    }

    // nft isIssued -> 모금이 종료되면 1로 바꾸기
    function _updtateNftIsIssued(uint64 _fundraiserId) internal {
        uint256 donationLength = donationsCount[_fundraiserId];
        for (uint64 i = 0; i < donationLength; i++) {
            fundraiserDonationList[_fundraiserId][i].isIssued = 1;
        }
    }

    // 후원
    // function _donate()




}