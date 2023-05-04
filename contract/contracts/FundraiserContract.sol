// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0 <0.9.0;


contract FundraiserProcess {

    struct Fundraiser { // 모금
        uint64 fundraiserId;
        string shelterId;
        address payable shelterAddress;
        string hashString; // ipfs hash
        uint256 currentAmount; // 현재 모인 금액
        uint256 targetAmount;
        bool isEnded; // 종료 되었는지, default false
    }

    uint64 private _fundraiserIdx;
    mapping(uint64 => Fundraiser) public fundraisers; // 모금


    function _createFundraiser(Fundraiser memory _fundraiser) internal {
        _fundraiserIdx++;
        _fundraiser.fundraiserId = _fundraiserIdx;
        fundraisers[_fundraiserIdx] = _fundraiser;
    }


    // 모금 종료
    function _endFundraiser(uint64 _fundraiserId) internal {
        fundraisers[_fundraiserId].isEnded = true;
    }

    // 모금 목록
    // function _getFundraiserList(bool _isEnded, uint16 _page, uint16 _size) internal view returns(Fundraiser[] memory){
    //     uint64 startIdx = _page * _size;
    //     uint64 endIdx = startIdx + _size;
    //     uint64 length = endIdx > _fundraiserIdx ? _fundraiserIdx : endIdx;
    //     uint64 count = 0;
    //     Fundraiser[] memory fundraiserList = new Fundraiser[](_size);

    //     uint64 i = startIdx;
    //     while (count < _size && i < length) {
    //         if (fundraisers[i].isEnded == _isEnded) {
    //             fundraiserList[count] = fundraisers[i];
    //             count++;
    //         }
    //         i++;
    //     }

    //         return fundraiserList;
    // }

    function _getFundraiserList() internal view returns(Fundraiser[] memory){

        Fundraiser[] memory fundraiserList = new Fundraiser[](_fundraiserIdx);

        for(uint64 i=1;i<=_fundraiserIdx;i++){
            fundraiserList[i-1] = fundraisers[i];
        }

        return fundraiserList;
    }

    // 내 모금 목록
    // function _getMyFundraiserList(string memory _shelterId, bool _isEnded, uint16 _page, uint16 _size) internal view returns (Fundraiser[] memory){
    //     uint64 startIdx = _page * _size;
    //     uint64 endIdx = startIdx + _size;
    //     uint64 length = endIdx > _fundraiserIdx ? _fundraiserIdx : endIdx;
    //     uint64 count = 0;
    //     Fundraiser[] memory myFundraiserList = new Fundraiser[](_size);

    //     uint64 i = startIdx;
    //     while (count < _size && i < length) {
    //         if (fundraisers[i].isEnded == _isEnded  && keccak256(bytes(fundraisers[i].shelterId)) == keccak256(bytes(_shelterId))) {
    //             myFundraiserList[count] = fundraisers[i];
    //             count++;
    //         }
    //         i++;
    //     }

    //     return myFundraiserList;
    // }

    // function _getMyFundraiserList(string memory _shelterId) internal view returns (Fundraiser[] memory){
    //     uint64 startIdx = _page * _size;
    //     uint64 endIdx = startIdx + _size;
    //     uint64 length = endIdx > _fundraiserIdx ? _fundraiserIdx : endIdx;
    //     uint64 count = 0;
    //     Fundraiser[] memory myFundraiserList = new Fundraiser[](_size);

    //     uint64 i = startIdx;
    //     while (count < _size && i < length) {
    //         if (fundraisers[i].isEnded == _isEnded  && keccak256(bytes(fundraisers[i].shelterId)) == keccak256(bytes(_shelterId))) {
    //             myFundraiserList[count] = fundraisers[i];
    //             count++;
    //         }
    //         i++;
    //     }

    //     return myFundraiserList;
    // }



    // 모금 상세
    function _getFundraiserDetail(uint64 _fundraiserId) internal view returns (Fundraiser memory){
        Fundraiser memory fundraiser = fundraisers[_fundraiserId];
        return fundraiser;
    }




}