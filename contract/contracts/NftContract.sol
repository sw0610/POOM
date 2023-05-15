// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./FundraiserContract.sol";
import "./DonationContract.sol";
import "../../backend/src/main/resources/node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NftProcess is ERC721URIStorage, FundraiserProcess, DonationProcess  {

    uint64 private _nftIds;
    mapping(string => uint64[]) private _memberNftList; // memberid -> nftid[]
    mapping(uint64 => NFT) private _nftList;

    struct NFT{
        string imageUrl;
        string metadataUri;
        uint256 issuedDate;
    }


    constructor() ERC721("PoomNFT", "POOM") {}

    function _mintNft(NFT memory _nft, address _memberAddress, string memory _memberId, uint64 _donationId, uint64 _fundraiserId) internal returns (uint64){
        require(fundraisers[_fundraiserId].isEnded==true, "Fundraiser is not ended.");
        require(donations[_donationId].isIssued==0 || donations[_donationId].isIssued==2, "Already issued.");


        ++_nftIds;

        _safeMint(_memberAddress, _nftIds); // nft 발급
        _setTokenURI(_nftIds, _nft.metadataUri); // nft TokenURI 저장

        if (_memberNftList[_memberId].length == 0) {
            _memberNftList[_memberId] = new uint64[](0);
        }
        _memberNftList[_memberId].push(_nftIds); // 멤버 id별 저장
        _nftList[_nftIds] = _nft;
        donations[_donationId].isIssued = 1;

        return _nftIds-1;

    }


    // nft 목록
    function _getNftList(string memory _memberId) internal view returns(NFT[] memory){
        uint256 nftCount = _memberNftList[_memberId].length;

        NFT[] memory nftListReponse = new NFT[](nftCount);

        for(uint64 i = 0; i < nftCount; i++){
            nftListReponse[i] = _nftList[_memberNftList[_memberId][i]];
        }

        return nftListReponse;
    }

}