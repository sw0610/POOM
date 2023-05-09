import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoApi {
  static Future<bool> checkKakaoToken() async {
    if (await AuthApi.instance.hasToken()) {
      try {
        AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
        print('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');

        return true;
      } catch (error) {
        if (error is KakaoException && error.isInvalidTokenError()) {
          print('토큰 만료 $error');
        } else {
          print('토큰 정보 조회 실패 $error');
        }
        return false;
      }
    } else {
      print('Does not have KakaoToken');
      return false;
    }
  }

  static Future<void> kakaoLogin() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();

      if (isInstalled) {
        //카카오톡으로 로그인
        await UserApi.instance.loginWithKakaoTalk();
      } else {
        //카카오 계정으로 로그인
        await UserApi.instance.loginWithKakaoAccount();
      }
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
    }
  }
}
