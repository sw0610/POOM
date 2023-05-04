import 'package:flutter/material.dart';
import 'package:poom/screens/collection_screen.dart';

class SupportItem extends StatelessWidget {
  static const _primaryColor = Color(0xFFFF8E01);
  static List<String> stateTypes = ["진행중", "발급완료", "발급가능"];
  static List<Color> stateColors = [
    Colors.amber.shade400,
    Colors.grey.shade400,
    Colors.green.shade400
  ];

  final String dogName, donateAmount, donateDate;
  final int isIssued;

  const SupportItem({
    super.key,
    required this.dogName,
    required this.donateAmount,
    required this.donateDate,
    required this.isIssued,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      decoration: const BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const SizedBox(
                    width: 68,
                    child: CachedImage(
                      imageUrl:
                          "https://i1.sndcdn.com/artworks-000660272461-rmfvxq-t500x500.jpg",
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dogName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text("$donateAmount eth",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        )),
                    Text(donateDate,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ))
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: stateColors.elementAt(isIssued),
                          shape: BoxShape.circle,
                        ),
                        width: 8,
                        height: 8,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        stateTypes.elementAt(isIssued),
                        style: const TextStyle(
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: isIssued == 2
                      ? TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: _primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {},
                          child: const Text("발급"),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
