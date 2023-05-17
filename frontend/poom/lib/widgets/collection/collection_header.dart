// 컬렉션 헤더
import 'package:flutter/material.dart';

class CollectionHeader extends StatelessWidget {
  static const Color _textColor = Color(0xFF333333);
  const CollectionHeader(
      {super.key, required this.nickName, required this.totalCount});

  final String nickName;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          nickName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _textColor,
          ),
        ),
        const Text(
          "님의 품",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _textColor,
          ),
        ),
      ],
    );
  }
}
