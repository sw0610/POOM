import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  static const textHintColor = Color(0xFF999999);
  static const primaryColor = Color(0xFFFF8E01);
  static const textColor = Color(0xFF333333);
  const DialogButton({
    super.key,
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
              side: const BorderSide(color: primaryColor),
            ),
          ),
          onPressed: () => Navigator.pop(context, "Ok"),
          child: const Text("확인"),
        ),
      ),
    );
  }
}
