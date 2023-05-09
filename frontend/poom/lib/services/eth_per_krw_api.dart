import 'package:dio/dio.dart';

class EthPerKrwApi {
  static Future<double> getEthPerKrw() async {
    try {
      Response response =
          await Dio().get('https://api.upbit.com/v1/ticker?markets=KRW-ETH');
      double tradePrice = response.data[0]['trade_price'];
      double ethPerKrw = (1 / tradePrice) * 1000; //1000원 당 몇 이더?
      ethPerKrw = (ethPerKrw * 1000000).floor() / 1000000; //소수점 여섯째자리까지.
      return ethPerKrw;
    } catch (error) {
      print(error);
      throw Exception("Failed to get eth per krw.");
    }
  }
}
