import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:poom/models/home/fundraiser_regist_model.dart';
import 'package:poom/services/auth_dio.dart';

class FundraiserApi {
  static Future<int> postFundraiserRegist({
    required BuildContext context,
    required File mainImage,
    required File nftImage,
    required List<File> dogImages,
    required FundraiserRegistModel fundraiserRegistModel,
  }) async {
    try {
      var formData = FormData.fromMap({
        'mainImage': await MultipartFile.fromFile(mainImage.path),
        'nftImage': await MultipartFile.fromFile(nftImage.path),
        'dogImages': List.generate(dogImages.length,
            (index) => MultipartFile.fromFileSync(dogImages[index].path)),
        'ageIsEstimated': fundraiserRegistModel.ageIsEstimated,
        'dogAge': fundraiserRegistModel.dogAge,
        'dogFeature': fundraiserRegistModel.dogFeature,
        'dogGender': fundraiserRegistModel.dogGender,
        'dogName': fundraiserRegistModel.dogName,
        'endDate': fundraiserRegistModel.endDate.toString(),
        'shelterEthWalletAddress':
            fundraiserRegistModel.shelterEthWalletAddress,
        'targetAmount': fundraiserRegistModel.targetAmount,
      });

      var dio = await authDio(context);
      final response = await dio.post('/fundraiser/open', data: formData);
      return response.data;
    } catch (e) {
      print('postFundraiserRegist ERROR: $e');
      throw Error();
    }
  }
}
