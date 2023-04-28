import 'package:flutter/material.dart';

class ProfileSupportScreen extends StatefulWidget {
  const ProfileSupportScreen({super.key});

  @override
  State<ProfileSupportScreen> createState() => _ProfileSupportScreenState();
}

class _ProfileSupportScreenState extends State<ProfileSupportScreen> {
  static const _textColor = Color(0xFF333333);
  static const _primaryColor = Color(0xFFFF8E01);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: _textColor,
          elevation: 1,
          title: const Text(
            "나의 후원 내역",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 24,
        ),
        child: Column(
          children: [
            const Row(
              children: [
                Text(
                  "최근 후원 내역",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            Container(
              height: 92,
              decoration: const BoxDecoration(),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Image.network(
                      "https://avatars.githubusercontent.com/u/38373150?v=4",
                      width: 68,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "귀여운 몽이",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text("3.000 eth",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            )),
                        Text("2023.03.01",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ))
                      ],
                    ),
                    Column(
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Text("상태"),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: _primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {},
                            child: const Text("발급"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
