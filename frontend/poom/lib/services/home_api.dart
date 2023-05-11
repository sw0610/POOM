import 'package:poom/models/home/home_dog_card_model.dart';
import 'package:poom/services/auth_dio.dart';

class HomeApi {
  static Future<List<dynamic>> getFundraiserList({
    context,
    required bool isClosed,
    required int page,
    required int size,
  }) async {
    try {
      var dio = await authDio(context);
      final response = await dio.get(
        '/fundraisers',
        queryParameters: {
          'isClosed': isClosed,
          'page': page,
          'size': size,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        List<HomeDogCardModel> fundraiserInstances = [];
        bool hasMore = responseData['hasMore'];
        List<dynamic> fundraisers = responseData['fundraiser'];

        for (var fundraiser in fundraisers) {
          fundraiserInstances.add(HomeDogCardModel.fromJson(fundraiser));
        }

        return [hasMore, fundraiserInstances];
      } else {
        print('ERROR CODE: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
