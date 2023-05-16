// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0 <0.9.0;


contract FundraiserProcess {

    struct Fundraiser { // 모금
        uint64 fundraiserId;
        string shelterId;
        address payable shelterAddress;
        string hashString; // ipfs hash
        uint256 startDate; // 모금 시작일
        uint256 currentAmount; // 현재 모인 금액
        uint256 targetAmount;
        bool isEnded; // 종료 되었는지, default false
        string donationSortHash;
    }

    uint64 private _fundraiserIdx;
    mapping(uint64 => Fundraiser) public fundraisers; // 모금

    function _createFundraiser(Fundraiser memory _fundraiser) internal {
        _fundraiserIdx++;
        _fundraiser.fundraiserId = _fundraiserIdx;
        fundraisers[_fundraiserIdx] = _fundraiser;

    }

    function _getFundraiserId() internal view returns (uint64){
        return _fundraiserIdx;
    }

    // 모금 종료
    function _endFundraiser(uint64 _fundraiserId) internal {
        fundraisers[_fundraiserId].isEnded = true;
    }


    function _getFundraiserList() internal view returns(Fundraiser[] memory){

        Fundraiser[] memory fundraiserList = new Fundraiser[](_fundraiserIdx);

        for(uint64 i=1;i<=_fundraiserIdx;i++){
            fundraiserList[i-1] = fundraisers[i];
        }

        return fundraiserList;
    }

    // 모금 상세
    function _getFundraiserDetail(uint64 _fundraiserId) internal view returns (Fundraiser memory){
        Fundraiser memory fundraiser = fundraisers[_fundraiserId];
        return fundraiser;
    }

}