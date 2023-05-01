import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final bool isShelter;
  final IconData? icon;
  final String title;
  final Function onTapMenu;

  const MenuItem({
    super.key,
    this.icon,
    required this.title,
    this.isShelter = false,
    required this.onTapMenu,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTapMenu();
      },
      child: Container(
        height: 60,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFF4F4F4),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            icon != null ? Icon(icon) : const SizedBox(),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
