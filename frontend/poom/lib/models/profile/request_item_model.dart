class RequestItemModel {
  final int fundraiserId, dogGender;
  final String dogName, mainImgUrl, nftImgUrl;
  final String? shelterName;
  final String endDate;
  final double currentAmount, targetAmount;

  RequestItemModel.fromJson(Map<String, dynamic> json)
      : fundraiserId = json['fundraiserId'],
        dogName = json['dogName'],
        mainImgUrl = json['mainImgUrl'],
        nftImgUrl = json['nftImgUrl'],
        dogGender = json['dogGender'],
        shelterName = json['shelterName'],
        endDate = json['endDate'],
        currentAmount = json['currentAmount'],
        targetAmount = json['targetAmount'];
}
