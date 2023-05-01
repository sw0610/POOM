// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./Fundraiser.sol";
import "./Donation.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
// import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NftProcess is ERC721URIStorage, Ownable, FundraiserProcess, DonationProcess  {

    uint64 private _nftIds;
    mapping(string => NFT[]) nftList; // memberid -> nftid[]

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

        if (nftList[_memberId].length == 0) {
            nftList[_memberId] = new NFT[](0);
        }
        // nftList[_memberId][nftList[_memberId].length - 1] = nft;
        nftList[_memberId].push(nft);

        _nftIds++;

        return _nftIds;
    }

    // nft 발급 -> isIssued = 2
    function _setNftIssued(uint64 _donationId) internal{
        require(_getDonation(_donationId).isIssued==1, "Already issued.");
        donations[_donationId].isIssued = 2;
    }

    // // nft 목록
    function _getNftList(string memory _memberId, uint64 page, uint64 size) internal view returns(NFT[] memory){
        uint256 nftCount = nftList[_memberId].length;
        uint64 startIdx = page * size;
        uint64 endIdx = startIdx + size;
        uint256 length = endIdx > nftCount ? nftCount : endIdx;

        NFT[] memory memberNftList = new NFT[](nftCount);

        for(uint64 i = startIdx; i < length; i++){
            memberNftList[i] = nftList[_memberId][i];
        }

        return memberNftList;
    }




    // function mintNft(string memory name, string memory description, string memory image, string memory dogName, string memory shelterName) external  returns (uint256) {
    //     uint256 tokenId = _tokenIds.current();
    //     _safeMint(msg.sender, tokenId);
    //     // _setTokenMetadata(tokenId, name, description, image, dogName, shelterName);
    //     _tokenIds.increment();
    //     return tokenId;
    // }


    // function getTokenURI(uint256 tokenId) public view returns (NFTMetadata memory) {
    //     _requireMinted(tokenId); // 존재하는지 확인
    //     return tokenURIs[tokenId];
    // }


}