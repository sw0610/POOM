import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:poom/main.dart';
import 'package:poom/services/auth_dio.dart';
import 'package:poom/services/kakao_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MemberApi {
  static const String baseUrl = 'https://k8a805.p.ssafy.io/api';
  static const storage = FlutterSecureStorage();

  static Future<void> getMemberInfo(BuildContext context) async {
    try {
      var dio = await authDio(context);
      var response = await dio.get('$baseUrl/members');

      print('회원정보 가져오기=================');
      print(response.data['shelterStatus'].runtimeType);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      if (response.data['shelterStatus'] == 'AUTH') {
        await preferences.setBool('isShelter', true);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> login(BuildContext context, bool refresh) async {
    //페이지 새로고침 함수
    void refreshScreen() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
      );
    }

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
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.setString('nickname', response.data['nickname']);
          await preferences.setBool('isShelter', response.data['shelter']);
          await preferences.setInt('loginStatus', 1);
          await preferences.setString('memberId', response.data["memberId"]);
          await storage.write(
              key: 'accesstoken', value: response.headers['accesstoken']![0]);

          await storage.write(
              key: 'refreshtoken', value: response.headers['refreshtoken']![0]);
          var accesstoken = await storage.read(key: 'accesstoken');
          print('Access token: $accesstoken');

          if (refresh) {
            //페이지 새로고침
            refreshScreen();
          }
        } else {
          print('Error Code: ${response.statusCode}');
        }
      } else {
        print('Invalid Kakao Token');
        await KakaoApi.kakaoLogin();
        login(context, true); //다시 로그인 시도
      }
    } catch (e) {
      print(e);
    }
  }
}
