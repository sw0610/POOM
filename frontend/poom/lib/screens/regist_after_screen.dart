import 'dart:io';

import 'package:flutter/material.dart';
import 'package:poom/models/home/fundraiser_regist_model.dart';
import 'package:poom/screens/home_specific_screen.dart';
import 'package:poom/services/fundraiser_api.dart';
import 'package:poom/widgets/loading/loading_widget.dart';

class RegistAfterScreen extends StatefulWidget {
  final File representImage;
  final File nftImage;
  final List<File> dogImages;
  final FundraiserRegistModel dogRegistInfo;

  const RegistAfterScreen({
    super.key,
    required this.representImage,
    required this.nftImage,
    required this.dogImages,
    required this.dogRegistInfo,
  });

  @override
  State<RegistAfterScreen> createState() => _RegistAfterScreenState();
}

class _RegistAfterScreenState extends State<RegistAfterScreen> {
  int fundraiserId = -1;

  void goDogSpecificScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DogSpecificScreen(
          fundraiserId: fundraiserId,
          context: context,
        ),
        fullscreenDialog: false,
      ),
    );
  }

  void doRegist() async {
    fundraiserId = await FundraiserApi.postFundraiserRegist(
      context: context,
      mainImage: widget.representImage,
      nftImage: widget.nftImage,
      dogImages: widget.dogImages,
      fundraiserRegistModel: widget.dogRegistInfo,
    );
    goDogSpecificScreen();
  }

  @override
  void initState() {
    super.initState();
    doRegist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: const LoadingWidget(
        title: '보호견을 블록체인에 등록하고 있습니다.',
        description: '약 20초가 소요됩니다.\n어플을 종료하지 마세요!',
      ),
    );
  }
}
