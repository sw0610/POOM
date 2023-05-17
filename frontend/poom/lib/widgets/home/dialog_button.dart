import 'package:flutter/material.dart';
import 'package:poom/screens/home_specific_screen.dart';

class DialogButton extends StatelessWidget {
  static const textHintColor = Color(0xFF999999);
  static const primaryColor = Color(0xFFFF8E01);
  static const textColor = Color(0xFF333333);
  late int result;
  late int fundraiserId;
  DialogButton({
    super.key,
    required this.result,
    required this.fundraiserId,
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
          onPressed: () {
            if (result == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DogSpecificScreen(
                    fundraiserId: fundraiserId,
                    context: context,
                  ),
                  fullscreenDialog: false,
                ),
              );
              return;
            }
            Navigator.pop(context, "Ok");
          },
          child: const Text(
            "확인",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
