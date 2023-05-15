import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poom/models/home/fundraiser_regist_model.dart';
import 'package:poom/widgets/regist/regist_nft_preview.dart';
import 'package:poom/widgets/regist/regist_representive_widget.dart';
import 'package:poom/widgets/regist/regist_specific_info_widget.dart';

class RegistScreen extends StatefulWidget {
  const RegistScreen({Key? key}) : super(key: key);

  @override
  _RegistScreenState createState() => _RegistScreenState();
}

class _RegistScreenState extends State<RegistScreen> {
  File? representImage;
  List<File> dogPhotoList = [];
  late FundraiserRegistModel dogRegistInfo;

  //메인 강아지 사진 고르기
  void _pickRepresentImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        representImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  //강아지 사진 여러장 고르기
  void _pickDogPhotoImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        dogPhotoList.add(File(pickedFile.path));
      } else {
        print('No image selected.');
      }
    });
  }

  //고른 강아지 사진 중에서 삭제
  void _deleteDogPhotoImage(int index) {
    setState(() {
      dogPhotoList.removeAt(index);
    });
  }

  void updateInfo(FundraiserRegistModel inputInfo) {
    dogRegistInfo = inputInfo;
    
  }

  //페이지 관리
  int _selectedIndex = 0; // 선택된 인덱스

  void nextPage() {
    if (_selectedIndex < 2) {
      setState(() {
        _selectedIndex = _selectedIndex + 1;
      });
    }
  }

  void prevPage() {
    if (_selectedIndex > 0) {
      setState(() {
        _selectedIndex = _selectedIndex - 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('보호견 등록'),
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: const Color(0xFF333333),
        centerTitle: true,
        elevation: 1,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          RegistRepresentive(
            nextPage: nextPage,
            representImage: representImage,
            pickRepresentImage: () => _pickRepresentImage(),
          ),
          RegistNftPreview(
            nextPage: nextPage,
            prevPage: prevPage,
          ),
          RegistSpecificInfo(
            dogPhotoList: dogPhotoList,
            pickDogPhotoImage: _pickDogPhotoImage,
            deleteDogPhotoImage: _deleteDogPhotoImage,
            updateInfo: updateInfo,
          ),
        ],
      ),
    );
  }
}
