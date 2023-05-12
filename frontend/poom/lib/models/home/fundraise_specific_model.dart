import 'dart:ffi';

class FundraiserSpecificModel {
  String dogName,
      shelterId,
      shelterName,
      shelterEthWalletAddress,
      mainImgUrl,
      nftImgUrl,
      dogFeature,
      endDate;
  int dogGender, dogAge;
  bool ageIsEstimated, isClosed;
  double targetAmount, currentAmount;
  Array donations;

  FundraiserSpecificModel.fromJson(Map<String, dynamic> json)
      : dogName = json['dogName'],
        shelterId = json['shelterId'],
        shelterName = json['shelterName'],
        shelterEthWalletAddress = json['shelterEthWalletAddress'],
        mainImgUrl = json['mainImgUrl'],
        nftImgUrl = json['nftImgUrl'],
        dogFeature = json['dogFeature'],
        endDate = json['endDate'],
        dogGender = json['dogGender'],
        dogAge = json['dogAge'],
        ageIsEstimated = json['ageIsEstimated'],
        isClosed = json['isClosed'],
        targetAmount = json['targetAmount'],
        currentAmount = json['currentAmount'],
        donations = json['donations'];
}
