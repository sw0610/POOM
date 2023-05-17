import 'package:flutter/material.dart';

class FullImageScreen extends StatelessWidget {
  final String imgUrl;

  const FullImageScreen({
    super.key,
    required this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF333333),
        foregroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFF333333),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 60.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
              image: DecorationImage(
                image: NetworkImage(imgUrl),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
