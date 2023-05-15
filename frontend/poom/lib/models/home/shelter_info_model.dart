class ShelterInfoModel {
  final String shelterId, shelterName, shelterAddress, shelterPhoneNumber;

  ShelterInfoModel.fromJson(Map<String, dynamic> json)
      : shelterId = json['shelterId'],
        shelterName = json['shelterName'],
        shelterAddress = json['shelterAddress'],
        shelterPhoneNumber = json['shelterPhoneNumber'];
}
