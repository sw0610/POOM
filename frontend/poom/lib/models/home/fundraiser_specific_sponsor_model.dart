class FundraiserSpecificSponsorModel {
  String memberId, nickname, profileImgUrl;
  double donationAmount;

  FundraiserSpecificSponsorModel.fromJson(Map<String, dynamic> json)
      : memberId = json['memberId'],
        nickname = json['nickname'],
        profileImgUrl = json['profileImgUrl'],
        donationAmount = json['donationAmount'];
}
