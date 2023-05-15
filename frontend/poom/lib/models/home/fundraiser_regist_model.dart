class FundraiserRegistModel {
  final bool ageIsEstimated;
  final int dogAge, dogGender;
  final String dogFeature, dogName, shelterEthWalletAddress;
  final DateTime endDate;
  final double targetAmount;

  FundraiserRegistModel.fromJson(Map<String, dynamic> json)
      : ageIsEstimated = json['ageIsEstimated'],
        dogAge = json['dogAge'],
        dogGender = json['dogGender'],
        dogFeature = json['dogFeature'],
        dogName = json['dogName'],
        shelterEthWalletAddress = json['shelterEthWalletAddress'],
        endDate = json['endDate'],
        targetAmount = json['targetAmount'];
}
