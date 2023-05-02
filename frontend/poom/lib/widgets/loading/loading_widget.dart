import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String? title, description;

  const Loading({
    super.key,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/gifs/gif_loading.gif",
            width: MediaQuery.of(context).size.width * 0.8,
          ),
          if (title != null)
            Text(
              title!,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Color(0xFF333333),
              ),
            ),
          if (description != null)
            Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
