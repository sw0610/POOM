// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0 <0.9.0;

import "./FundraiserContract.sol";

contract DonationProcess is FundraiserProcess {

    struct Donation { // 후원
        string memberId;
        uint256 donationId;
        uint256 donationAmount; // 후원 금액
        uint64 fundraiserId; // 모금 id
        uint256 donationTime; // 모금 시간
        uint8 isIssued; // nft 발급 여부
    }

    uint64 private _donationId;

    mapping(string => mapping(uint64=>uint64)) public memberToFundraiser; // memberid => fundraiserid -> 후원 id
    mapping(uint64=>Donation) public donations; //  후원 id -> 후원 내역
    mapping(uint64 => uint64[]) public fundraiserDonationList; // 모금 id -> 후원자들

    mapping(uint64 => uint256) public donationsCount; // 모금 id -> 후원자 수


    function _getDonationList() internal view returns (Donation[] memory){
        Donation[] memory donationList = new Donation[](_donationId);

        for(uint64 i =0 ; i < _donationId; i++){
            donationList[i] = donations[i+1];
        }
        return donationList;
    }

    // nft isIssued -> 모금이 종료되면 2로 모두 변경
    function _setNftFundraiserEnded(uint64 _fundraiserId) internal {

        uint256 donationLength = donationsCount[_fundraiserId];
        for (uint64 i = 0; i < donationLength; i++) {
            donations[fundraiserDonationList[_fundraiserId][i]].isIssued = 2;
        }
    }

    // donation 한개 가져오기
    function _getDonation(uint64 _id) internal view returns (Donation memory){
        return donations[_id];
    }


    // 후원자 정렬 hash 저장
    function _setDonationSort(uint64 _fundraiserId, string memory _sortHash) internal {
        fundraisers[_fundraiserId].donationSortHash = _sortHash;
    }

    // 후원자 정렬 hash 가져오기
    function _getDonationSort(uint64 _fundraiserId) internal view returns(string memory){
        return fundraisers[_fundraiserId].donationSortHash;
    }


    // 후원
    function _donate(uint64 _fundraiserId, string memory _memberId, uint256 _donationTime, uint256 _value) internal{
        require(_value >0, "Value must be more then 0");
        require(_value <= fundraisers[_fundraiserId].targetAmount-fundraisers[_fundraiserId].currentAmount, "Value must be little then target amount");
        require(fundraisers[_fundraiserId].isEnded == false,"Fundraiser is ended");

        if(donations[memberToFundraiser[_memberId][_fundraiserId]].donationAmount==0){
            Donation memory donation = Donation(
                {memberId:_memberId,
                donationId:++_donationId,
                fundraiserId:_fundraiserId,
                donationAmount:0,
                donationTime:_donationTime,
                isIssued: 0});
            memberToFundraiser[_memberId][_fundraiserId] = _donationId;

            donations[memberToFundraiser[_memberId][_fundraiserId]] = donation;

            // memberDonationList[_memberId].push(_donationId);
            donations[_donationId] = donation;
            fundraiserDonationList[_fundraiserId].push(_donationId);
            donationsCount[_fundraiserId]+=1;
        }


        donations[memberToFundraiser[_memberId][_fundraiserId]].donationTime = _donationTime;
        donations[memberToFundraiser[_memberId][_fundraiserId]].donationAmount+=_value;
        fundraisers[_fundraiserId].currentAmount +=_value;
        address payable shelterAddress = fundraisers[_fundraiserId].shelterAddress;
        shelterAddress.transfer(_value);


        // 목표 금액을 넘겼으면 끝내기
        if(fundraisers[_fundraiserId].currentAmount== fundraisers[_fundraiserId].targetAmount){
            _endFundraiser(_fundraiserId);
            _setNftFundraiserEnded(_fundraiserId);
        }

    }



}