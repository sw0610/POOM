import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:poom/screens/login_screen.dart';
import 'package:poom/screens/progress_indicator_screen.dart';
import 'package:poom/widgets/poom_page_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await dotenv.load(fileName: 'assets/config/.env');
  String? nativeAppKey = dotenv.env['NATIVE_APP_KEY'];
  KakaoSdk.init(nativeAppKey: nativeAppKey);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int loginStatus = 2; //0: 미로그인 상태. 1: 로그인 상태, 2: 기본상태(로딩)

  void getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      int? value = prefs.getInt('loginStatus');
      print("loginStatus 값: $value");
      print("loginStatus 타입: ${value.runtimeType}");

      if (value == null) {
        loginStatus = 0;
        print('받은 value가 null임!');
      } else {
        loginStatus = value;
        print('받은 value가 null이 아님!');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getLoginStatus();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POOM',
      theme: ThemeData(
        primaryColor: const Color(0xFFFF8E01),
        fontFamily: "SUIT",
        colorScheme: ColorScheme.fromSwatch(backgroundColor: Colors.white),
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: loginStatus == 0
            ? const LoginScreen()
            : loginStatus == 1
                ? const PoomPageState()
                : const ProgressIndicatorScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
