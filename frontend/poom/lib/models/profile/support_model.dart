class SupportModel {
  final int donationId, fundraiserId, isIssued;
  final String nftImgUrl, dogName, donateDate;
  final double donateAmount;

  SupportModel.fromJson(Map<String, dynamic> json)
      : donationId = json["donationId"],
        fundraiserId = json["fundraiserId"],
        isIssued = json["isIssued"],
        nftImgUrl = json["nftImgUrl"],
        dogName = json["dogName"],
        donateDate = json["donateDate"],
        donateAmount = json["donateAmount"];
}
