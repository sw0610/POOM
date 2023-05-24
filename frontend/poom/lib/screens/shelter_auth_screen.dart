import 'package:flutter/material.dart';
import 'package:poom/models/profile/shelter_model.dart';
import 'package:poom/services/member_api.dart';
import 'package:poom/services/shelter_api.dart';
import 'package:shimmer/shimmer.dart';

class ShelterAuthScreen extends StatefulWidget {
  const ShelterAuthScreen({super.key});

  @override
  State<ShelterAuthScreen> createState() => _ShelterAuthScreenState();
}

class _ShelterAuthScreenState extends State<ShelterAuthScreen> {
  static const Color _textColor = Color(0xFF333333);
  late Future<ShelterModel> shelterInfo;

  void getAccessToken() async {
    await MemberApi.login(context, false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shelterInfo = ShelterApiService().getShelterInfo(context);
    // access token 재발급
    getAccessToken();
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
          foregroundColor: _textColor,
          elevation: 1,
          title: const Text(
            "보호소 회원 인증",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "인증 내역",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      FutureBuilder(
                        future: shelterInfo,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              height: 190,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.7),
                                    blurRadius: 4.0,
                                    spreadRadius: 0.0,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFF8E01),
                                    Color(0xFFFFB75C),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data!.shelterName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      snapshot.data!.shelterAddress,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      snapshot.data!.shelterPhoneNumber,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 48,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "ID ${snapshot.data!.shelterId}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return Shimmer.fromColors(
                            baseColor: const Color(0xFFFFB75C),
                            highlightColor: Colors.white,
                            child: Container(
                              height: 178,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFF8E01),
                                    Color(0xFFFFB75C),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: 20,
                        right: 54,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(60, 251, 216, 152),
                            shape: BoxShape.circle,
                          ),
                          width: 76,
                          height: 76,
                        ),
                      ),
                      Positioned(
                        top: 48,
                        right: 12,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(70, 251, 216, 152),
                            shape: BoxShape.circle,
                          ),
                          width: 76,
                          height: 76,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
