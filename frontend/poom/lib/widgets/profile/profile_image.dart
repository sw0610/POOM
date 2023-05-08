import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key, required this.isEditMode});

  final bool isEditMode;

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  // 파일 이미지
  File? _image;
  final imagePicker = ImagePicker();

  Future getProfileImage(ImageSource imageSource) async {
    final profileImage = await imagePicker.pickImage(source: imageSource);

    if (profileImage != null) {
      setState(() {
        _image = File(profileImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 화면 세로 비율 고정
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return GestureDetector(
      onTap: () {
        if (!widget.isEditMode) return;
        getProfileImage(ImageSource.gallery);
      },
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: _image != null
                    ? FileImage(
                        File(
                          _image!.path,
                        ),
                      ) as ImageProvider
                    : const NetworkImage('https://picsum.photos/250?image=9'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          widget.isEditMode && _image != null
              ? Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _image = null;
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
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
