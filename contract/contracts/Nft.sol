// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./Fundraiser.sol";
import "./Donation.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";
// import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
contract NftProcess is ERC721URIStorage, Ownable, FundraiserProcess, DonationProcess  {

    using Counters for Counters.Counter;
    Counters.Counter private _nftIds;
    mapping(string => uint256[]) nftList; // memberid -> nftid[]

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
    function _mintNft(string memory _memberId, uint64 _fundraiserId,  uint64 _donationId, string memory _metadataUri, string memory _imgUrl) internal returns (uint64) {

        require(_getFundraiserDetail(_fundraiserId).isEnded==true, "Fundraiser is not ended.");
        require(_getDonation(_donationId).isIssued==1, "Already issued.");

        uint256 nftId = _nftIds.current();
        _safeMint(msg.sender, nftId);
         _setTokenURI(nftId, _metadataUri);
        _nftIds.increment();


        NFT nft = NFT(
            {nftId:_nftId,
            memberId:_memberId,
            fundraiserId:_fundraiserId,
            imgUrl:_imgUrl});
        nftList[_memberId].push(nft);

        return nftId;
    }

    function _setNftIssued(uint64 _donationId) internal{
        require(_getDonation(_donationId).isIssued==1, "Already issued.");
        donations[_donationId].isIssued = 2;
    }






    // nft 목록
    function _getNftList(string memory _memberId) internal returns(){


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