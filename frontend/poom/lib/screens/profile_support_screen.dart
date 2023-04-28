import 'package:flutter/material.dart';

class ProfileSupportScreen extends StatefulWidget {
  const ProfileSupportScreen({super.key});

  @override
  State<ProfileSupportScreen> createState() => _ProfileSupportScreenState();
}

class _ProfileSupportScreenState extends State<ProfileSupportScreen> {
  static const _textColor = Color(0xFF333333);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: _textColor,
          elevation: 1,
          title: const Text(
            "나의 후원 내역",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: const Padding(
          padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 24,
      )),
    );
  }
}
