class HomeDogCardModel {
  final int fundraiserId, dogGender;
  final String dogName, mainImgUrl, nftImgUrl, shelterName, dogFeature;
  final String endDate;
  final double currentAmount, targetAmount;

  HomeDogCardModel.fromJson(Map<String, dynamic> json)
      : fundraiserId = json['fundraiserId'],
        dogName = json['dogName'],
        mainImgUrl = json['mainImgUrl'],
        nftImgUrl = json['nftImgUrl'],
        dogGender = json['dogGender'],
        shelterName = json['shelterName'],
        endDate = json['endDate'],
        currentAmount = json['currentAmount'],
        targetAmount = json['targetAmount'],
        dogFeature = json['dogFeature'];
}
