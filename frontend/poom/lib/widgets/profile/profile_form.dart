import 'package:flutter/material.dart';
import 'package:poom/widgets/profile/profile_image.dart';

// Form
class ProfileForm extends StatefulWidget {
  const ProfileForm(
      {super.key,
      required this.nickname,
      required this.email,
      required this.profileImgUrl});

  final String nickname, email, profileImgUrl;
  static const _textColor = Color(0xFF333333);

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  static const _inputBackgroundColor = Color(0xFFFAFAFA);

  bool isEditMode = false;

  void onUpdateProfile() {
    setState(() {
      isEditMode = !isEditMode;
    });
  }

  // form key 설정
  final _formKey = GlobalKey<FormState>();
  late String _nickname, _profileImgUrl;

  @override
  void initState() {
    super.initState();
    _nickname = widget.nickname;
    _profileImgUrl = widget.profileImgUrl;
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
            ProfileImage(isEditMode: isEditMode),
            const SizedBox(
              height: 20,
            ),
            isEditMode
                ? SizedBox(
                    width: 312,
                    height: 48,
                    child: TextFormField(
                      initialValue: _nickname,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: _inputBackgroundColor,
                        hintText: "닉네임을 입력해주세요.",
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: _inputBackgroundColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: _inputBackgroundColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: _inputBackgroundColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.always,
                      onSaved: (newValue) {
                        _nickname = newValue as String;
                      },
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length > 16) {
                          return "닉네임은 최소 2글자부터 최대 15글자까지 입력 가능합니다.";
                        }
                        return null;
                      },
                    ),
                  )
                : Text(
                    _nickname,
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
