import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:poom/services/kakao_api.dart';
import 'package:poom/services/member_api.dart';
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
    isLogin = MemberApi.login();
  }

  void doLogin() async {
    await KakaoApi.kakaoLogin();
    setState(() {
      isLogin = MemberApi.login();
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
                body: Container(
                  alignment: Alignment.center,
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/img_logo.png',
                        width: 140,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      const Text(
                        'POOM',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(
                        height: 220,
                      ),
                      GestureDetector(
                        onTap: doLogin,
                        child: Image.asset(
                          'assets/images/img_kakaologin.png',
                          width: 200,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          } else {
            return Scaffold(
              body: Container(
                color: Theme.of(context).primaryColor,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
