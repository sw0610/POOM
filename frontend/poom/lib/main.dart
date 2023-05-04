import 'package:flutter/material.dart';
import 'package:poom/services/kakao_login_api.dart';
import 'package:poom/widgets/login/login_widget.dart';
import 'package:poom/widgets/poom_page_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static late Future<bool> isLogin;

  @override
  void initState() {
    super.initState();
    isLogin = KakaoLoginApi.isLogin();
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
      home: FutureBuilder(
        future: isLogin,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //유효한 토큰을 가지고 있는 사용자라면
            if (snapshot.data!) {
              return const Scaffold(
                resizeToAvoidBottomInset: false,
                body: PoomPageState(),
              );
            } else {
              return const LoginWidget();
            }
          } else {
            return const Scaffold(
              body: Center(
                child: Text('Loading...'),
              ),
            );
          }
        },
      ),
    );
  }
}
