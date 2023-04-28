import 'package:flutter/material.dart';

class ValueText extends StatelessWidget {
  final String value;

  const ValueText({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: const TextStyle(
        color: Color(0xFF333333),
        fontSize: 14,
      ),
    );
  }
}
