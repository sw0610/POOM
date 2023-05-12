import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:poom/services/auth_dio.dart';

class NftApiService {
  void getUserNFTList(
      BuildContext context, int pageNum, String memberId) async {
    var logger = Logger();
    try {
      var dio = await authDio(context);
      final response = await dio
          .get("/members/nfts?size=10&page=$pageNum&memberId=$memberId");
      logger.i("[NftApiService] getUserNFTList() success $response");
    } catch (e) {
      logger.e("[NftApiService] getUserNFTList() fail $e");
      throw Error();
    }
  }
}
