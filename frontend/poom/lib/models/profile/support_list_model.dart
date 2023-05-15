/* 프로필 - 나의 후원 내역 아이템 모델
 */
class SupportItemModel {
  final String nftImgUrl, dogName, donationAmount, donationDate, donationId;
  final int isIssued;

  SupportItemModel.fromJson(Map<String, dynamic> json)
      : nftImgUrl = json["nftImgUrl"],
        dogName = json["dogName"],
        donationAmount = json["donationAmount"],
        donationDate = json["donationDate"],
        donationId = json["donationId"],
        isIssued = json["isIssued"];
}
