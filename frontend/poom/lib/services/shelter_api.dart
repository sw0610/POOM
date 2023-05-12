import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:poom/models/profile/shelter_model.dart';
import 'package:poom/services/auth_dio.dart';

class Cond {
  String? shelterId;
  String shelterName, shelterAddress, shelterPhoneNumber;
  Cond({
    shelterId,
    required this.shelterName,
    required this.shelterAddress,
    required this.shelterPhoneNumber,
  });

  @override
  String toString() {
    return "shelterName=$shelterName";
  }
}

class ShelterApiService {
  static const baseUrl = "https://k8a805.p.ssafy.io/api";

  // 내 보호소 정보 조회
  Future<ShelterModel> getShelterInfo(BuildContext context) async {
    var logger = Logger();
    try {
      // test shelterId
      var shelterId = "645d8e887cbf190a63026eec";
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
