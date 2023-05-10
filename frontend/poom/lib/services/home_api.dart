import 'package:poom/services/auth_dio.dart';

class HomeApi {
  static Future<void> getFundraiserList({
    context,
    required bool isClosed,
    required int page,
    required int size,
  }) async {
    try {
      var dio = await authDio(context);
      var response = await dio.get(
        '/fundraisers',
        queryParameters: {
          'isClosed': isClosed,
          'page': page,
          'size': size,
        },
      );
      print(response);
    } catch (e) {
      print(e);
    }
  }
}
