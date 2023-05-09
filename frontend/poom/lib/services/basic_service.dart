import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BasicService {
  static const baseUrl = "https://k8a805.p.ssafy.io/api/";
  static final BasicService _basicService = BasicService._internal();
  static Dio _dio = Dio();

  factory BasicService() => _basicService;

  BasicService._internal() {
    BaseOptions baseOptions = BaseOptions(
      baseUrl: baseUrl,
      headers: {
        "Authorization": getToken(),
      },
    );

    _dio = Dio(baseOptions);
  }

  Dio to() {
    return _dio;
  }

  Future<String> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('accesstoken')!;
  }
}
