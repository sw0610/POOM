import 'package:flutter/material.dart';

class ClassificationText extends StatelessWidget {
  final String classification;

  const ClassificationText({
    super.key,
    required this.classification,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 66,
      child: Text(
        classification,
        style: const TextStyle(
          color: Color(0xFF666666),
          fontSize: 12,
        ),
      ),
    );
  }
}
