import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:poom/models/profile/user_info_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileApiService {
  static const baseUrl = "https://k8a805.p.ssafy.io/api";

  Future<UserInfoModel> getUserProfile() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      // var dio = await authDio();
      var dio = Dio(BaseOptions(baseUrl: baseUrl));
      dio.options.headers['Authorization'] =
          preferences.getString("accesstoken");
      final response = await dio.get("/members");
      var responseToString = response.toString();
      return UserInfoModel.fromJson(jsonDecode(responseToString));
    } catch (e) {
      print("[ProfileApiService] getUserProfile() : $e");
      throw Error();
    }
  }
}
