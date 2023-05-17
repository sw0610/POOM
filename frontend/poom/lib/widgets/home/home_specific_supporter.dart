import 'package:flutter/material.dart';
import 'package:poom/screens/user_collection_screen.dart';

class Supporter extends StatelessWidget {
  final String nickname, imgPath, memberId;
  final double amount;

  const Supporter(
      {super.key,
      required this.nickname,
      required this.imgPath,
      required this.amount,
      required this.memberId,
      s});

  @override
  Widget build(BuildContext context) {
    void goNftScreen() {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserCollectionScreen(memberId: memberId),
            fullscreenDialog: true,
          ));
    }

    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: goNftScreen,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              clipBehavior: Clip.antiAlias,
              width: 35,
              height: 35,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
              child: Image.network(
                imgPath,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              nickname,
              style: const TextStyle(
                color: Color(0xFF666666),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '$amount eth',
              style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            )
          ]),
        ),
      ],
    );
  }
}
