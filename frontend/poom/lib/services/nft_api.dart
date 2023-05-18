import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:poom/services/auth_dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NftApiService {
  Future<Map<String, dynamic>> getUserNFTList(
      BuildContext context, int pageNum) async {
    var logger = Logger();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var memberId = preferences.getString("memberId");
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

  Future<Map<String, dynamic>> getAnotherUserNFTList(
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

  Future<bool> issueNFt(BuildContext context, Map<String, dynamic> data) async {
    Logger logger = Logger();
    try {
      var dio = await authDio(context);
      var response = await dio.post("/donations/nft/issued", data: data);
      logger.i("[NftService] issueNFT success $response");
      return true;
    } catch (e) {
      logger.e("[NftService] issueNFt fail $e");
      return false;
    }
  }
}
