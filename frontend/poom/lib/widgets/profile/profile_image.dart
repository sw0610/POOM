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

    setState(() {
      _image = File(profileImage!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 화면 세로 비율 고정
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return ClipOval(
      child: SizedBox.fromSize(
        size: const Size.fromRadius(64),
        child: GestureDetector(
          onTap: () {
            if (!widget.isEditMode) return;
            getProfileImage(ImageSource.gallery);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Center(
              child: _image == null
                  ? const Text("NO IMAGE")
                  : Image.file(
                      File(
                        _image!.path,
                      ),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
