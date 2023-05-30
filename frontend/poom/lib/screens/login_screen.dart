import 'package:flutter/material.dart';
import 'package:poom/services/member_api.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void doLogin() async {
      await MemberApi.login(context, true);
    }

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
}
