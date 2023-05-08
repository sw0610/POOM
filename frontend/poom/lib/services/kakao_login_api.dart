import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLoginApi {
  static Future<bool> isLogin() async {
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

  static Future<bool> login() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();

      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      print('accestoken: ${token.accessToken}');

      final url = Uri.https('kapi.kakao.com', '/v2/user/me');

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
        },
      );

      final profileInfo = json.decode(response.body);
      print(profileInfo.toString());

      //토큰이 저장되었는지 확인. 저장 안되어있으면 false 리턴
      Future<bool> isTokenSaved;
      isTokenSaved = isLogin();
      return isTokenSaved;
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
      return false;
    }
  }
}
