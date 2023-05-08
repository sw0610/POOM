class HomeDogCardModel {
  final int fundraiserId;
  final String dogName, mainImgUrl, nftImgUrl, dogGender, shelterName;
  final DateTime endDate;
  final double currendAmount, targetAmount;

  HomeDogCardModel.fromJson(Map<String, dynamic> json)
      : fundraiserId = json['fundraiserId'],
        dogName = json['dogName'],
        mainImgUrl = json['mainImgUrl'],
        nftImgUrl = json['nftImgUrl'],
        dogGender = json['dogGender'],
        shelterName = json['shelterName'],
        endDate = json['endDate'],
        currendAmount = json['currendAmount'],
        targetAmount = json['targetAmount'];
}
