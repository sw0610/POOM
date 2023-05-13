import 'package:poom/models/home/fundraiser_specific_model.dart';
import 'package:poom/models/home/fundraiser_specific_sponsor_model.dart';
import 'package:poom/models/home/home_dog_card_model.dart';
import 'package:poom/services/auth_dio.dart';

class HomeApi {
  // static Future<List<dynamic>> getSpecificFundraiser({context, required int fundraiserId,}) {
  static Future<FundraiserSpecificModel> getSpecificFundraiser({
    required context,
    required int fundraiserId,
  }) async {
    try {
      var dio = await authDio(context);
      final response = await dio.get('/fundraisers/$fundraiserId');

      FundraiserSpecificModel fundraiserSpecificModelInstance =
          FundraiserSpecificModel.fromJson(response.data);
      List<FundraiserSpecificSponsorModel> donationsInstances = [];
      if (fundraiserSpecificModelInstance.donations.isNotEmpty) {
        for (var donation in fundraiserSpecificModelInstance.donations) {
          donationsInstances
              .add(FundraiserSpecificSponsorModel.fromJson(donation));
        }
        fundraiserSpecificModelInstance.donations = donationsInstances;
      }
      return fundraiserSpecificModelInstance;
    } catch (e) {
      print('getSpecificFundraiser ERROR: $e');
      throw Error();
    }
  }

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

      Map<String, dynamic> responseData = response.data;
      List<HomeDogCardModel> fundraiserInstances = [];
      bool hasMore = responseData['hasMore'];
      List<dynamic> fundraisers = responseData['fundraiser'];

      for (var fundraiser in fundraisers) {
        fundraiserInstances.add(HomeDogCardModel.fromJson(fundraiser));
      }

      return [hasMore, fundraiserInstances];
    } catch (e) {
      print('getFundraiserList ERROR: $e');
      throw Error();
    }
  }
}
