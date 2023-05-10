import 'package:flutter/material.dart';
import 'package:poom/models/profile/user_info_model.dart';
import 'package:poom/screens/profile_settings_screen.dart';
import 'package:poom/screens/profile_support_request_screen.dart';
import 'package:poom/screens/profile_support_screen.dart';
import 'package:poom/screens/shelter_auth_form_screen.dart';
import 'package:poom/screens/shelter_auth_screen.dart';
import 'package:poom/services/profile_api_service.dart';
import 'package:poom/widgets/profile/profile_form.dart';
import 'package:poom/widgets/profile/profile_menu.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const _textColor = Color(0xFF333333);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // API호출을 통해 받아올 Future 데이터 처리(userId, userEmail, profileImg)
  // 임시 데이터 처리

  late Future<UserInfoModel> user;
  String nickname = "songo427";
  String email = "songo427@gmail.com";
  String profileImgUrl = "https://avatars.githubusercontent.com/u/38373150?v=4";
  bool isHideMenu = false;
  int authStatus = 2;

  void setHideMenu() {
    setState(() {
      isHideMenu = !isHideMenu;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = ProfileApiService().getUserProfile(context);
  }

  @override
  Widget build(BuildContext context) {
    onTapSettingButton() async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileSettingsScreen(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: ProfileScreen._textColor,
          shadowColor: const Color(0xFFE4E4E4),
          centerTitle: true,
          elevation: 1,
          actions: [
            isHideMenu
                ? const SizedBox()
                : IconButton(
                    onPressed: onTapSettingButton,
                    icon: const Icon(Icons.settings),
                  ),
          ],
          title: const Text(
            "나의 프로필",
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
          children: [
            SizedBox(
              height: 286,
              child: FutureBuilder(
                  future: user,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ProfileForm(
                        nickname: snapshot.data!.nickname,
                        email: snapshot.data!.email,
                        profileImgUrl: snapshot.data!.profileImgUrl,
                        setHideMenu: setHideMenu,
                      );
                    }
                    return ProfileForm(
                      nickname: "",
                      email: "",
                      profileImgUrl: "",
                      setHideMenu: setHideMenu,
                    );
                  }),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 32,
                ),
                isHideMenu
                    ? const SizedBox()
                    : Column(
                        children: [
                          MenuItem(
                            icon: Icons.request_page,
                            title: "후원 요청 목록",
                            isShelter: true,
                            onTapMenu: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SupportRequestScreen(),
                                ),
                              );
                            },
                          ),
                          MenuItem(
                            icon: Icons.receipt,
                            title: "나의 후원 내역",
                            onTapMenu: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ProfileSupportScreen(),
                                ),
                              );
                            },
                          ),
                          MenuItem(
                            icon: Icons.night_shelter_rounded,
                            title: "보호소 회원 인증",
                            isShelter: true,
                            onTapMenu: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  if (authStatus == 1) {
                                    // 인증 상태
                                    return const ShelterAuthScreen();
                                  }
                                  return const ShelterAuthFormScreen();
                                }),
                              );
                            },
                          ),
                        ],
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
