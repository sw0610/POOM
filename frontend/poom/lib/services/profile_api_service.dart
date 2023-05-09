import 'package:poom/services/basic_service.dart';

class ProfileApiService {
  static const baseUrl = "https://k8a805.p.ssafy.io/api/";

  void getUserProfile() async {
    try {
      var dio = BasicService().to();
      final response = await dio.get("/members");
      print(response);
    } catch (e) {
      print(e);
    }
  }
}
