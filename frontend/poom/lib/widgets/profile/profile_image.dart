import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({
    super.key,
    required this.profileImgUrl,
    required this.isEditMode,
    required this.pickProfileImage,
  });

  final Function pickProfileImage;
  final String profileImgUrl;
  final bool isEditMode;

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  // 파일 이미지
  File? _image;
  final imagePicker = ImagePicker();
  late Future<String> result;

  Future getProfileImage(ImageSource imageSource) async {
    final profileImage = await imagePicker.pickImage(source: imageSource);

    if (profileImage != null) {
      setState(() {
        _image = File(profileImage.path);
        widget.pickProfileImage(profileImage.path);
      });
    }
  }

  Future<String> getUserProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? path = preferences.getString("profileImgUrl");
    const defaultPath =
        "https://ipfs.io/ipfs/QmQUNZ8jxkPSdnQ4MhDgC4pmB3xUjpAxWQsqJd1NvC4viL";
    return path ?? defaultPath;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    result = getUserProfile();
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
          _image != null
              ? Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(
                        File(_image!.path),
                      ),
                    ),
                  ),
                )
              : Container(
                  width: 100,
                  height: 100,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: FutureBuilder(
                    future: result,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return CachedNetworkImage(
                          imageUrl: snapshot.data!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade100,
                            highlightColor: Colors.white,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        );
                      }
                      return const Text("heoll");
                    },
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
                        widget.pickProfileImage(null);
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
