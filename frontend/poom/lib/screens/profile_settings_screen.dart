import 'package:flutter/material.dart';
import 'package:poom/widgets/profile/profile_menu.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  static const _textColor = Color(0xFF333333);
  static const _textHintColor = Color(0xFF999999);
  static const _primaryColor = Color(0xFFFF8E01);

  Future<String?> onTapOpenDialog(
      BuildContext context, String title, String guideMessage) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        elevation: 1,
        title: Text(
          textAlign: TextAlign.center,
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          textAlign: TextAlign.center,
          guideMessage,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        buttonPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        actions: const <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DialogButton(
                primaryColor: Color(0xFFF9F9F9),
                textColor: _textHintColor,
                isCancel: true,
              ),
              SizedBox(
                width: 20,
              ),
              DialogButton(
                primaryColor: _primaryColor,
                textColor: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: _textColor,
          elevation: 1,
          title: const Text(
            "설정",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            MenuItem(
              title: "버전정보",
              onTapMenu: () {},
            ),
            MenuItem(
              title: "오픈소스",
              onTapMenu: () {},
            ),
            MenuItem(
              title: "계정탈퇴",
              onTapMenu: () {
                onTapOpenDialog(context, "계정탈퇴", "정말로 탈퇴하시겠습니까?");
              },
            ),
            MenuItem(
              title: "로그아웃",
              onTapMenu: () {
                onTapOpenDialog(context, "로그아웃", "로그아웃 하시겠습니까?");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DialogButton extends StatelessWidget {
  final Color primaryColor;
  final Color textColor;
  final bool isCancel;

  const DialogButton({
    super.key,
    required this.primaryColor,
    required this.textColor,
    this.isCancel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 42,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: primaryColor),
            ),
          ),
          onPressed: () => Navigator.pop(context, isCancel ? "Cancel" : "Ok"),
          child: Text(isCancel ? "취소" : "확인"),
        ),
      ),
    );
  }
}
