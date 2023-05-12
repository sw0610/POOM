class FundraiserSpecificModel {
  String dogName,
      shelterId,
      shelterName,
      shelterAddress,
      shelterEthWalletAddress,
      mainImgUrl,
      nftImgUrl,
      dogFeature,
      endDate;
  int dogGender, dogAge;
  bool ageIsEstimated, isClosed;
  double targetAmount, currentAmount;
  List donations, dogImgUrls;

  FundraiserSpecificModel.fromJson(Map<String, dynamic> json)
      : dogName = json['dogName'],
        shelterId = json['shelterId'],
        shelterName = json['shelterName'],
        shelterAddress = json['shelterAddress'],
        shelterEthWalletAddress = json['shelterEthWalletAddress'],
        mainImgUrl = json['mainImgUrl'],
        nftImgUrl = json['nftImgUrl'],
        dogImgUrls = json['dogImgUrls'],
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
