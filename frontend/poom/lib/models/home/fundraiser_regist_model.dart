class FundraiserRegistModel {
  final bool ageIsEstimated;
  final int dogAge, dogGender;
  final String dogFeature, dogName;
  String shelterEthWalletAddress;
  final DateTime endDate;
  final double targetAmount;

  FundraiserRegistModel({
    required this.ageIsEstimated,
    required this.dogAge,
    required this.dogGender,
    required this.dogFeature,
    required this.dogName,
    required this.shelterEthWalletAddress,
    required this.endDate,
    required this.targetAmount,
  });

  factory FundraiserRegistModel.fromJson(Map<String, dynamic> json) {
    return FundraiserRegistModel(
      ageIsEstimated: json['ageIsEstimated'],
      dogAge: json['dogAge'],
      dogGender: json['dogGender'],
      dogFeature: json['dogFeature'],
      dogName: json['dogName'],
      shelterEthWalletAddress: json['shelterEthWalletAddress'],
      endDate: json['endDate'],
      targetAmount: json['targetAmount'],
    );
  }
}
