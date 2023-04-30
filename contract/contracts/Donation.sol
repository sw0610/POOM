// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0 <0.9.0;

import "./Fundraiser.sol";

contract DonationContract is Fundraiser {

    struct Donation { // 후원
        string memberId;
        uint256 donationAmount; // 후원 금액
        uint64 fundraiserId; // 모금 id
        uint256 donationTime; // 모금 시간
        bool isIssued; // nft 발급 여부
    }


    mapping(uint64 => uint256) public myFundraiserCount; // shelterId => my fundraiserCount
    mapping(uint64 => mapping(uint256=>Donation)) public donations; // 모금 id -> 후원자들
    mapping(uint64 => uint256) public donationsCount; // 모금 id -> 후원자 수

        // 후원자 목록
    function _getDonationList(uint64 _fundraiserId) internal view returns (Donation[] memory) {
        uint256 donationLength = donationsCount[_fundraiserId];
        Donation[] memory donationList = new Donation[](donationLength);

        for (uint256 i = 0; i < donationLength; i++) {
            donationList[i] = donations[_fundraiserId][i];
        }

        return donationList;
    }


}