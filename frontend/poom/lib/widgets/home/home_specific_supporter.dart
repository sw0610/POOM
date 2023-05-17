import 'package:flutter/material.dart';

class Supporter extends StatelessWidget {
  final String nickname, imgPath, memberId;
  final double amount;

  const Supporter({
    super.key,
    required this.nickname,
    required this.imgPath,
    required this.amount,
    required this.memberId,
  });

  void goNftScreen() {
    //NFT 발급 페이지로 이동
  }

  @override
  Widget build(BuildContext context) {
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
