import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class KakaoMapWidget extends StatefulWidget {
  final String shelterAddress;
  const KakaoMapWidget({
    super.key,
    required this.shelterAddress,
  });

  @override
  State<KakaoMapWidget> createState() => _KakaoMapWidgetState();
}

class _KakaoMapWidgetState extends State<KakaoMapWidget> {
  String KAKAO_MAP_KEY = '';
  String GOOGLE_GEOCODING_KEY = '';
  double lat = 37.501286;
  double lng = 127.0396029;
  String wrongAddress = '';

  //주소로 위도 경도 가져오기
  Future<void> getLocation() async {
    await dotenv.load(fileName: 'assets/config/.env');
    setState(() {
      KAKAO_MAP_KEY = dotenv.env['KAKAO_MAP_KEY']!;
      GOOGLE_GEOCODING_KEY = dotenv.env['GOOGLE_GEOCODING_KEY']!;
    });

    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${widget.shelterAddress}&key=$GOOGLE_GEOCODING_KEY';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
      },
    );
    final decodedResponse = json.decode(response.body);

    if (decodedResponse['status'] != 'OK') {
      setState(() {
        wrongAddress = '주소의 위치를 찾을 수 없습니다.\n기본 위치를 표시합니다.';
      });
    } else {
      setState(() {
        lat = decodedResponse['results'][0]['geometry']['location']['lat'];
        lng = decodedResponse['results'][0]['geometry']['location']['lng'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    if (KAKAO_MAP_KEY != '') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KakaoMapView(
            width: MediaQuery.of(context).size.width,
            height: 200,
            kakaoMapKey: KAKAO_MAP_KEY,
            lat: lat,
            lng: lng,
            showMapTypeControl: true,
            showZoomControl: true,
            markerImageURL:
                'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
          ),
          const SizedBox(
            height: 10,
          ),
          if (wrongAddress != '')
            Text(
              wrongAddress,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
