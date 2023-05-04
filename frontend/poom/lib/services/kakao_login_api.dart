import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLoginApi {
  static const String appKey = '16f9dc70727d623363f37d2a4e117611';

  static Future<bool> isLogin() async {
    KakaoSdk.init(nativeAppKey: appKey);
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
      return false;
    }
  }

  static void login() async {
    KakaoSdk.init(nativeAppKey: appKey);
    const String redirectUri = 'https://k8a805.p.ssafy.io/api/oauth/kakao';
    try {
      await AuthCodeClient.instance.authorize(
        redirectUri: redirectUri,
      );
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
    }
  }
}
