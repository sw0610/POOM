import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Dio> authDio(BuildContext context) async {
  const String baseUrl = 'https://k8a805.p.ssafy.io/api';
  var dio = Dio(BaseOptions(baseUrl: baseUrl));
  const storage = FlutterSecureStorage();

  void goFirstPage() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  dio.interceptors.clear();

  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
    // 기기에 저장된 AccessToken 로드
    final accessToken = await storage.read(key: 'accesstoken');

    // 매 요청마다 헤더에 AccessToken을 포함
    options.headers['Authorization'] = accessToken;
    return handler.next(options);
  }, onError: (error, handler) async {
    // 인증 오류가 발생했을 경우: AccessToken의 만료
    if (error.response?.statusCode == 401) {
      // 기기에 저장된 AccessToken과 RefreshToken 로드
      final refreshToken = await storage.read(key: 'refreshtoken');

      // 토큰 갱신 요청을 담당할 dio 객체 구현 후 그에 따른 interceptor 정의
      var refreshDio = Dio();

      refreshDio.interceptors.clear();

      refreshDio.interceptors
          .add(InterceptorsWrapper(onError: (error, handler) async {
        // 다시 인증 오류가 발생했을 경우: RefreshToken의 만료
        if (error.response?.statusCode == 401) {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          // 기기의 자동 로그인 정보 삭제
          await storage.deleteAll();
          await prefs.clear();
          goFirstPage();
        }
        return handler.next(error);
      }));

      // 토큰 갱신 API 요청 시 AccessToken(만료), RefreshToken 포함
      refreshDio.options.headers['Authorization'] = refreshToken;
      // refreshDio.options.headers['Refresh'] = refreshToken;

      // 토큰 갱신 API 요청
      final refreshResponse = await refreshDio.get('$baseUrl/member/refresh');

      // response로부터 새로 갱신된 AccessToken과 RefreshToken 파싱
      final newAccessToken = refreshResponse.headers['accesstoken']![0];
      final newRefreshToken = refreshResponse.headers['refreshtoken']![0];

      // 기기에 저장된 AccessToken과 RefreshToken 갱신
      await storage.write(key: 'accesstoken', value: newAccessToken);
      await storage.write(key: 'refreshtoken', value: newRefreshToken);

      // AccessToken의 만료로 수행하지 못했던 API 요청에 담겼던 AccessToken 갱신
      error.requestOptions.headers['Authorization'] = newAccessToken;

      // 수행하지 못했던 API 요청 복사본 생성
      final clonedRequest = await dio.request(error.requestOptions.path,
          options: Options(
              method: error.requestOptions.method,
              headers: error.requestOptions.headers),
          data: error.requestOptions.data,
          queryParameters: error.requestOptions.queryParameters);

      // API 복사본으로 재요청
      return handler.resolve(clonedRequest);
    }

    return handler.next(error);
  }));

  return dio;
}
