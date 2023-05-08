import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberApi {
  static const String baseUrl = 'https://k8a805.p.ssafy.io/api';

  static void login() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('accessToken') ?? '';
      print('accessToken: $accessToken');

      var dio = Dio();
      dio.options.headers['Authorization'] = accessToken;
      var response = await dio.get('$baseUrl/member/login');
      print(response.data);
    } catch (e) {
      print(e);
    }
  }
}
