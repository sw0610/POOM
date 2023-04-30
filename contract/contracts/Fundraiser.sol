// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0 <0.9.0;


contract FundraiserContract {

    struct Donation { // 후원
        string memberId;
        uint256 donationAmount; // 후원 금액
        uint64 fundraiserId; // 모금 id
        uint256 donationTime; // 모금 시간
        bool isIssued; // nft 발급 여부
    }

    struct Fundraiser { // 모금
        string shelterId;
        string hashString; // ipfs hash
        uint256 currentAmount; // 현재 모인 금액
        bool isEnded; // 종료 되었는지, defautl false
    }

    uint64 private _fundraiserIdx; 
    mapping(uint64 => Fundraiser) public fundraisers; // 모금
    // mapping(uint64 => uint64) public myFundraisers; // shelterid -> fundraiserid
    // mapping(uint64 => uint256) public fundraiserCount; // fundraiserId => fundraiserCount

    mapping(uint64 => uint256) public myFundraiserCount; // shelterId => my fundraiserCount
    mapping(uint64 => mapping(uint256=>Donation)) public donations; // 모금 id -> 후원자들
    mapping(uint64 => uint256) public donationsCount; // 모금 id -> 후원자 수

    /*
        모금
        모금id -> 모금
        모금 개수 mapping
        나의 모금만 가져오려면? 

        후원
        모금 id -> (후원자 id->후원) mapping
        후원 개수 mapping
    */
    

    /*
    1. 모금
        - 모금 등록 o
        - 모금 종료 o
        - 모금 목록 
            - 전체 o
            - 보호소별 o
        - 모금 상세 o
    2. 후원
        - 모금별 후원자 목록
        - 후원
        - 내 후원 목록

    3. nft
        - nft 발급
        - nft 목록
    */

    // 모금 등록
    function createFundraiser(string calldata _hashString) internal returns (uint64) {
        uint64 _fundraiserId = _fundraiserIdx++;
        fundraisers[_fundraiserIdx].hashString = _hashString;

        return _fundraiserId;
    }

    // 모금 종료
    function endFundraiser(uint64 _fundraiserId) internal {
        fundraisers[_fundraiserId].isEnded = true;
    }

    // 모금 목록
    function getFundraiserList(bool _isEnded, uint64 page, uint64 size) internal view returns(Fundraiser[] memory){
        uint64 startIdx = page * size;
        uint64 endIdx = startIdx + size;
        uint64 length = endIdx > _fundraiserIdx ? _fundraiserIdx : endIdx;
        uint64 count = 0;
        Fundraiser[] memory fundraiserList = new Fundraiser[](size);

        uint64 i = startIdx;
        while (count < size && i < length) {
            if (fundraisers[i].isEnded == _isEnded) {
                fundraiserList[count] = fundraisers[i];
                count++;
            }
            i++;
        }

            return fundraiserList;
    }

    // 내 모금 목록
    function getMyFundraiserList(string memory _shelterId, bool _isEnded, uint64 page, uint64 size) internal view returns (Fundraiser[] memory){
        uint64 startIdx = page * size;
        uint64 endIdx = startIdx + size;
        uint64 length = endIdx > _fundraiserIdx ? _fundraiserIdx : endIdx;
        uint64 count = 0;
        Fundraiser[] memory myFundraiserList = new Fundraiser[](size);

        uint64 i = startIdx;
        while (count < size && i < length) {
            if (fundraisers[i].isEnded == _isEnded  && keccak256(bytes(fundraisers[i].shelterId)) == keccak256(bytes(_shelterId))) {
                myFundraiserList[count] = fundraisers[i];
                count++;
            }
            i++;
        }

        return myFundraiserList;
    }

    // 모금 상세
    function getFundraiserDetail(uint64 _fundraiserId) internal view returns (Fundraiser memory){
        Fundraiser memory fundraiser = fundraisers[_fundraiserId];
        return fundraiser;
    }

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