import 'package:flutter/material.dart';
import 'package:poom/services/kakao_login_api.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            print('카카오 로그인 버튼 클릭');
            KakaoLoginApi.login();
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
}
