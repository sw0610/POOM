import 'package:flutter/material.dart';
import 'package:poom/services/profile_api_service.dart';
import 'package:poom/widgets/profile/profile_image.dart';

// Form
class ProfileForm extends StatefulWidget {
  ProfileForm({
    super.key,
    required this.nickname,
    required this.email,
    required this.profileImgUrl,
    required this.setHideMenu,
  });

  String? nickname;
  final String email, profileImgUrl;
  final Function setHideMenu; // 프로필 페이지 메뉴 숨김 여부
  static const _textColor = Color(0xFF333333);

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  static const _inputBackgroundColor = Color(0xFFFAFAFA);
  dynamic file;
  String? changedNickname;
  bool isEditMode = false;

  void onUpdateProfile() async {
    var isUpdated = false;
    widget.setHideMenu();

    if (isEditMode) {
      Map<String, dynamic> data = {
        "file": file,
        "nickname": changedNickname == "" ? widget.nickname : changedNickname
      };
      isUpdated = await ProfileApiService().updateUserProfile(context, data);
    }

    setState(() {
      isEditMode = !isEditMode;
      widget.nickname =
          changedNickname == "" ? widget.nickname : changedNickname;
      if (isUpdated) {
        ProfileApiService().getUserProfile(context);
      }
    });
  }

  void pickProfileImage(dynamic pickedFile) {
    file = pickedFile;
  }

  // form key 설정
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    changedNickname = widget.nickname;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onUpdateProfile,
                  child: Text(
                    isEditMode ? "저장" : "수정",
                    style: const TextStyle(
                      color: ProfileForm._textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            ProfileImage(
                profileImgUrl: widget.profileImgUrl,
                isEditMode: isEditMode,
                pickProfileImage: pickProfileImage),
            const SizedBox(
              height: 20,
            ),
            isEditMode
                ? SizedBox(
                    width: 312,
                    height: 48,
                    child: TextFormField(
                      initialValue: widget.nickname,
                      onChanged: (value) {
                        setState(() {
                          changedNickname = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: _inputBackgroundColor,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 0, color: _inputBackgroundColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 0, color: _inputBackgroundColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                : Text(
                    widget.nickname!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
            const SizedBox(
              height: 4,
            ),
            Text(
              isEditMode ? "" : widget.email,
              style: const TextStyle(
                color: Color(0xFF666666),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
