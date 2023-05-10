// 프로필 - 사용자의 프로필 정보를 담을 모델 클래스
class UserInfoModel {
  final String memberId, nickname, profileImgUrl, email;
  final int? shelterStatus;
  final String? shelterId;

  UserInfoModel.fromJson(Map<String, dynamic> json)
      : memberId = json["memberId"],
        nickname = json["nickname"],
        profileImgUrl = json["profileImgUrl"],
        email = json["email"],
        shelterStatus = json["shelterStatus"],
        shelterId = json["shelterId"];
}
