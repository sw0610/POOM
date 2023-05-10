import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poom/models/profile/user_info_model.dart';
import 'package:poom/services/auth_dio.dart';

class ProfileApiService {
  static const baseUrl = "https://k8a805.p.ssafy.io/api";

  Future<UserInfoModel> getUserProfile(BuildContext context) async {
    try {
      var dio = await authDio(context);
      final response = await dio.get("/members");
      print("response? $response");
      var responseToString = response.toString();
      return UserInfoModel.fromJson(jsonDecode(responseToString));
    } catch (e) {
      print("[ProfileApiService] getUserProfile() : $e");
      throw Error();
    }
  }
}
