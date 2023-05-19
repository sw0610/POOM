import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kpostal/kpostal.dart';
import 'package:poom/services/shelter_api.dart';
import 'package:poom/widgets/profile/text_input.dart';

class ShelterAuthFormScreen extends StatefulWidget {
  const ShelterAuthFormScreen({super.key});

  @override
  State<ShelterAuthFormScreen> createState() => _ShelterAuthFormScreenState();
}

class _ShelterAuthFormScreenState extends State<ShelterAuthFormScreen> {
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

  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];

  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    print(imageFileList);
    // 5개 초과시 안내 메세지 보이기
    if (imageFileList.length >= 6) {
      print("5개까지 등록 가능해요!");
      return;
    }

    setState(() {});
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
      body: SingleChildScrollView(
        child: Padding(
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
                  onChanged: (newValue) {
                    _shelterName = newValue;
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
                const Row(
                  children: [
                    Text(
                      "보호소 주소",
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
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.only(left: 16),
                        alignment: Alignment.centerLeft,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAFAFA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _shelterAddress == ""
                            ? const Text(
                                "보호소 주소를 찾아주세요.",
                                style: TextStyle(
                                  color: Color(0xFF666666),
                                ),
                              )
                            : Text(
                                _shelterAddress,
                                style: const TextStyle(
                                  color: Color(0xFF333333),
                                ),
                              ),
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => KpostalView(
                                useLocalServer: true,
                                localPort: 8080,
                                callback: (Kpostal result) {
                                  print("result: $result.address");
                                  setState(() {
                                    _shelterAddress = result.address;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        child: const Text("주소 찾기"))
                  ],
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
                  onChanged: (newValue) {
                    _shelterPhone = newValue;
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
                SingleChildScrollView(
                  child: Row(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              selectImages();
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFFF9F9F9),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              width: 54,
                              height: 54,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/ic_camera.svg",
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.scaleDown,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  const Text(
                                    "사진 첨부",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: imageFileList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 5,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Image.file(
                                    File(imageFileList[index].path),
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: -10,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          imageFileList.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black,
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.close_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0,
                            color: const Color(0xFFFF8E01),
                          ),
                          color: const Color(0xFFFF8E01),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            if (_shelterAddress == "") {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("보호소 주소는 필수 입력 정보 입니다."),
                              ));
                              return;
                            }

                            if (imageFileList.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("증명서류는 필수 첨부 자료입니다."),
                              ));
                              return;
                            }

                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              if (imageFileList.isEmpty) return;
                              ShelterApiService().certifyShelter(context, {
                                "certificateImages": imageFileList,
                                "cond": {
                                  'shelterName': _shelterName,
                                  'shelterAddress': _shelterAddress,
                                  'shelterPhoneNumber': _shelterPhone,
                                }
                              });

                              Navigator.pop(context);
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
      ),
    );
  }
}
