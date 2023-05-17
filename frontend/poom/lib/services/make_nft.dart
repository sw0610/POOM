import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class MakeNft {
  static Future<File?> getNft({
    required File mainImg,
  }) async {
    try {
      print('nft 파일 받기 시작');
      var formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(mainImg.path),
      });

      var dio = Dio();
      var response = await dio.post(
        'http://10.0.2.2:8080/nfts',
        data: formData,
        options: Options(responseType: ResponseType.bytes),
      );

      //nft 생성 완료
      var documentDirectory = await getApplicationDocumentsDirectory();
      var filePath = '${documentDirectory.path}/image.jpg';

      File nftImg = File(filePath);
      await nftImg.writeAsBytes(response.data);
      return nftImg;
      //강아지가 아님
    } catch (e) {
      print('getNft ERROR: $e');
      return null;
    }
  }
}
