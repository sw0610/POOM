import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:poom/models/profile/shelter_model.dart';
import 'package:poom/services/auth_dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShelterApiService {
  static const baseUrl = "https://k8a805.p.ssafy.io/api";

  void certifyShelter(BuildContext context, Map<String, dynamic> data) async {
    var logger = Logger();
    try {
      var dio = await authDio(context);

      List<XFile> list = data["certificateImages"];
      List<File> imageFiles = [File(list.first.path)];
      List<MultipartFile> multipartFiles =
          await Future.wait(imageFiles.map((imageFile) async {
        return await MultipartFile.fromFile(imageFile.path);
      }));

      var cond = data["cond"];

      FormData formData = FormData.fromMap({
        'certificateImages': multipartFiles,
        'shelterName': cond["shelterName"],
        'shelterAddress': cond["shelterAddress"],
        'shelterPhoneNumber': cond["shelterPhoneNumber"],
      });

      final response = await dio.post("/shelters/auth", data: formData);
      logger.i("[ShelterApiService] certifyShelter() success $response");
    } catch (e) {
      logger.e("[ShelterApiService] certifyShelter() fail $e");
    }
  }

  // 내 보호소 정보 조회
  Future<ShelterModel> getShelterInfo(BuildContext context) async {
    var logger = Logger();
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var shelterId = preferences.getString("shelterId");
      print("shelterId $shelterId");
      var dio = await authDio(context);
      final response = await dio.get("/shelters/$shelterId");
      logger.i("[ShelterApiService] getShelterInfo() success $response");

      var responseToString = response.toString();
      return ShelterModel.fromJson(jsonDecode(responseToString));
    } catch (e) {
      logger.e("[ShelterApiService] getShelterInfo() fail $e");
      throw Error();
    }
  }
}
