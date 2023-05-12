class ShelterModel {
  String shelterId,
      shelterName,
      shelterAddress,
      shelterPhoneNumber,
      shelterStatus,
      regDate;

  ShelterModel.fromJson(Map<String, dynamic> json)
      : shelterId = json["shelterId"],
        shelterName = json["shelterName"],
        shelterAddress = json["shelterAddress"],
        shelterPhoneNumber = json["shelterPhoneNumber"],
        shelterStatus = json["shelterStatus"],
        regDate = json["regDate"];
}
