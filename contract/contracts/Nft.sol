// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./Fundraiser.sol";
import "./Donation.sol";
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

    // mapping(uint256 => NFTMetadata) tokenURIs;


    /*
        nft 발급
            - metadata 생성해서 uri 받아오기
        발급 받은 후 isIssued 변경
        회원별 nft 목록
    */


    constructor() ERC721("PoomNFT", "POOM") {}

    // nft 발급
    function _mintNft(string memory _memberId, uint64 _fundraiserId,  uint64 _donationId, string memory _metadataUri, string memory _imageUrl) internal returns (uint64) {

        require(_getFundraiserDetail(_fundraiserId).isEnded==true, "Fundraiser is not ended.");
        require(_getDonation(_donationId).isIssued==1, "Already issued.");

        _safeMint(msg.sender, _nftIds);
        _setTokenURI(_nftIds, _metadataUri);


        NFT memory nft = NFT(
            {nftId:_nftIds,
            memberId:_memberId,
            fundraiserId:_fundraiserId,
            imageUrl:_imageUrl});

        if (_memberNftList[_memberId].length == 0) {
            _memberNftList[_memberId] = new uint64[](0);
        }
        // nftList[_memberId][nftList[_memberId].length - 1] = nft;
        _memberNftList[_memberId].push(_nftIds);
        _nftList[_nftIds] = nft;

        _nftIds++;

        return _nftIds-1;
    }

    // nft 발급 -> isIssued = 2
    function _setNftIssued(uint64 _donationId) internal{
        require(_getDonation(_donationId).isIssued==1, "Already issued.");
        donations[_donationId].isIssued = 2;
    }

    // // nft 목록
    function _getNftList(string memory _memberId, uint64 _page, uint64 _size) internal view returns(NFT[] memory){
        uint256 nftCount = _memberNftList[_memberId].length;
        uint64 startIdx = _page * _size;
        uint64 endIdx = startIdx + _size;
        uint256 length = endIdx > nftCount ? nftCount : endIdx;

        NFT[] memory nftListReponse = new NFT[](length);

        for(uint64 i = startIdx; i < length; i++){
            nftListReponse[i-startIdx] = _nftList[_memberNftList[_memberId][i]];
        }

        return nftListReponse;
    }

}