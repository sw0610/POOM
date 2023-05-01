import 'package:flutter/material.dart';
import 'package:poom/widgets/profile/text_input.dart';

class ShelterAuthScreen extends StatefulWidget {
  const ShelterAuthScreen({super.key});

  @override
  State<ShelterAuthScreen> createState() => _ShelterAuthScreenState();
}

class _ShelterAuthScreenState extends State<ShelterAuthScreen> {
  static const Color _textColor = Color(0xFF333333);
  final _formKey = GlobalKey<FormState>();

  String _shelterName = "";
  String _shelterAddress = "";
  String _shelterPhone = "";

  // 보호소 이름 validate
  onCheckShelterName(value) {
    RegExp pattern = RegExp(r'^[a-zA-Z가-힣]{1,15}$');
    if (!pattern.hasMatch(value)) {
      return "사용할 수 없는 보호소 이름입니다.";
    }
    return null;
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
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "인증 등록",
                style: TextStyle(
                  color: _textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "보호소 인증 절차를 통해 회원을 전환하실 수 있어요!",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              TextInput(
                initValue: _shelterName,
                title: "보호소 이름",
                placeholder: "보호소 이름을 입력하세요.",
                onSaved: (newValue) {
                  setState(() {
                    _shelterName = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "보호소 이름은 필수 입력 사항 입니다.";
                  }
                  return onCheckShelterName(value);
                },
              ),
              const SizedBox(
                height: 24,
              ),
              TextInput(
                initValue: _shelterAddress,
                title: "보호소 주소",
                placeholder: "보호소 주소를 입력하세요.",
                onSaved: (newValue) {
                  setState(() {
                    _shelterAddress = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "보호소 주소는 필수 입력 사항입니다.";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 24,
              ),
              TextInput(
                initValue: _shelterPhone,
                title: "대표 전화번호",
                placeholder: "-를 포함하여 입력하세요.",
                onSaved: (newValue) {
                  setState(() {
                    _shelterPhone = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "대표 전화번호는 필수 입력 사항입니다.";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 24,
              ),
              const Row(
                children: [
                  Text(
                    "증명서류",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                  Text(
                    "*",
                    style: TextStyle(
                      color: Color(
                        0xFFFF4040,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "최대 5개의 증명 서류를 등록할 수 있어요!",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0,
                          color: const Color(0xFFFF8E01),
                        ),
                        color: const Color(0xFFFF8E01),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          print("onPressed().. $_shelterName");
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save(); // onSaved 콜백 실행
                          }
                        },
                        child: const Text(
                          "인증",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
