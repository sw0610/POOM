import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:poom/services/auth_dio.dart';

class NftApiService {
  Future<Map<String, dynamic>> getUserNFTList(
      BuildContext context, int pageNum, String memberId) async {
    var logger = Logger();

    try {
      var dio = await authDio(context);
      final response = await dio
          .get("/members/nfts?size=10&page=$pageNum&memberId=$memberId");

      Map<String, dynamic> result = {
        "hasMore": response.data["hasMore"],
        "nickname": response.data["nickname"],
        "nftCount": response.data["nftCount"],
        "nftImgUrls": response.data["nftImgUrls"]
      };

      logger.i("[NftApiService] getUserNFTList() success $response");
      return result;
    } catch (e) {
      logger.e("[NftApiService] getUserNFTList() fail $e");
      throw Error();
    }
  }
}
