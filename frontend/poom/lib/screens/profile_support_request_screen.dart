import 'package:flutter/material.dart';
import 'package:poom/services/profile_api_service.dart';
import 'package:poom/widgets/profile/request_drop_down.dart';

class SupportRequestScreen extends StatefulWidget {
  const SupportRequestScreen({super.key});
  static const _textColor = Color(0xFF333333);

  @override
  State<SupportRequestScreen> createState() => _SupportRequestScreenState();
}

class _SupportRequestScreenState extends State<SupportRequestScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ProfileApiService().getMySupportRequestList(context, 0, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: SupportRequestScreen._textColor,
          elevation: 1,
          title: const Text(
            "후원 요청 목록",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "동물사랑센터",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: SupportRequestScreen._textColor,
                  ),
                ),
                RequestDropDown(),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFF4F4F4),
                            width: 1,
                          ),
                        ),
                      ),
                      child: const RequestItem(),
                    );
                  },
                  itemCount: 5),
            ),
          ],
        ),
      ),
    );
  }
}

class RequestItem extends StatelessWidget {
  static const Color _textColor = Color(0xFF333333);
  const RequestItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("아이템 클릭");
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    "https://avatars.githubusercontent.com/u/38373150?v=4",
                    width: 100,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      "https://blog.kakaocdn.net/dn/3QnFw/btrzDuGrysQ/eFkkwdOTgJnPkO9XPTIZM1/img.png",
                      width: 32,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 14,
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "몽이",
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.ac_unit,
                      size: 16,
                      color: _textColor,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      "후원 마감일",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "2023.03.1",
                      style: TextStyle(
                        color: _textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "현재 모금액",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "1.2345 eth",
                      style: TextStyle(
                        color: _textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "목표 후원금",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "4.21 eth",
                      style: TextStyle(
                        color: _textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
