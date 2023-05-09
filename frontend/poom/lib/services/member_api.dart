import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:poom/services/kakao_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberApi {
  static const String baseUrl = 'https://k8a805.p.ssafy.io/api';

  static Future<void> getMemberInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var dio = Dio();
      dio.options.headers['Authorization'] = prefs.getString('accesstoken');
      var response = await dio.get('$baseUrl/members');
      print('회원정보 가져오기=================');
      print(response);
    } catch (e) {
      print(e);
    }
  }

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
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('nickname', response.data);
          await prefs.setString(
              'accesstoken', response.headers['accesstoken']![0]);
          await prefs.setString(
              'refreshtoken', response.headers['refreshtoken']![0]);

          print('AccessToken: ${prefs.getString('accesstoken')}');

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
