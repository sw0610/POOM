import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:poom/models/profile/user_info_model.dart';
import 'package:poom/services/auth_dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileApiService {
  static const baseUrl = "https://k8a805.p.ssafy.io/api";

  Future<UserInfoModel> getUserProfile(BuildContext context) async {
    var logger = Logger();
    try {
      var dio = await authDio(context);
      final response = await dio.get("/members");

      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('nickname', response.data['nickname']);
      await preferences.setString(
          'profileImgUrl', response.data['profileImgUrl']);

      var responseToString = response.toString();
      logger.i("[ProfileApiService] getUserProfile() success");
      return UserInfoModel.fromJson(jsonDecode(responseToString));
    } catch (e) {
      logger.e("[ProfileApiService] getUserProfile() fail $e");
      throw Error();
    }
  }

  Future<bool> updateUserProfile(
      BuildContext context, Map<String, dynamic> data) async {
    var logger = Logger();
    try {
      var dio = await authDio(context);
      var file = data["file"];

      final formData = FormData.fromMap({
        'profileImage': file == null ? null : await MultipartFile.fromFile(file)
      });

      await dio.put(
        "/members?nickname=${data["nickname"]}",
        data: formData,
      );
      logger.i("[ProfileApiService] updateUserProfile() success");

      return true;
    } catch (e) {
      logger.e("[ProfileApiService] updateUserProfile() fail $e");
      throw Error();
    }
  }

  void getMySupportList(BuildContext context, int pageNum) async {
    var logger = Logger();
    try {
      var dio = await authDio(context);
      final response =
          await dio.get("/members/donations?page=$pageNum&size=10");
      logger.i("[ProfileApiService] getMySupportList() success $response.data");
    } catch (e) {
      logger.e("[ProfileApiService] getMySupportList() fail $e");
    }
  }
}
