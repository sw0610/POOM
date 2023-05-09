import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:poom/services/kakao_api.dart';

class MemberApi {
  static const String baseUrl = 'https://k8a805.p.ssafy.io/api';

  static Future<bool> login() async {
    try {
      //카카오 토큰이 유효한지 체크
      bool isValidToken = await KakaoApi.checkKakaoToken();

      //유효한 카카오 토큰이라면
      //서비스 서버로 accessToken 담아서 로그인 처리
      if (isValidToken) {
        var token = await TokenManagerProvider.instance.manager.getToken();
        print('카카오 accessToken: ${token!.accessToken}');

        var dio = Dio();
        dio.options.headers['Authorization'] = token.accessToken;
        var response = await dio.get('$baseUrl/member/login');

        if (response.statusCode == 200) {
          print(response.data);
          print(response.headers);
          return true;
        } else {
          print('Error Code: ${response.statusCode}');
          return false;
        }
      } else {
        print('Invalid Kakao Token');
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
