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
        uint64 nftId;
        uint64 fundraiserId;
        string memberId;
        string imageUrl;
    }


    constructor() ERC721("PoomNFT", "POOM") {}

    // nft 발급
    function _mintNft(string memory _memberId, uint64 _fundraiserId,  uint64 _donationId, string memory _metadataUri, string memory _imageUrl, address memberAddress) internal returns (uint64) {
        require(_getFundraiserDetail(_fundraiserId).isEnded==true, "Fundraiser is not ended.");
        require(_getDonation(_donationId).isIssued==1, "Already issued.");

        _nftIds++;

        _safeMint(memberAddress, _nftIds); // nft 발급
        _setTokenURI(_nftIds, _metadataUri); // nft TokenURI 저장


        NFT memory nft = NFT(
            {nftId:_nftIds,
            memberId:_memberId,
            fundraiserId:_fundraiserId,
            imageUrl:_imageUrl});

        if (_memberNftList[_memberId].length == 0) {
            _memberNftList[_memberId] = new uint64[](0);
        }
        _memberNftList[_memberId].push(_nftIds); // 멤버 id별 저장
        _nftList[_nftIds] = nft; 


        return _nftIds-1;
    }

    // nft 발급 -> isIssued = 2
    function _setNftIssued(uint64 _donationId) internal{
        require(_getDonation(_donationId).isIssued==1, "Already issued.");
        donations[_donationId].isIssued = 2;
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