import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:poom/services/kakao_login_api.dart';
import 'package:poom/widgets/poom_page_state.dart';

void main() {
  const String nativeAppKey = '0902572b5f1cb7155e2c40b83d1d0fc6';
  KakaoSdk.init(nativeAppKey: nativeAppKey);
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

  void checkIsLogin(Future<bool> isLoginAfter) {
    setState(() {
      isLogin = isLoginAfter;
    });
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
              return Scaffold(
                body: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isLogin = KakaoLoginApi.login();
                        print('main.dart: $isLogin');
                      });
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 200,
                      decoration: const BoxDecoration(
                        color: Colors.yellow,
                      ),
                      child: const Text('카카오로 로그인 하기'),
                    ),
                  ),
                ),
              );
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
