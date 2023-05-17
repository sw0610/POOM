import 'dart:io';

import 'package:flutter/material.dart';
import 'package:poom/models/home/fundraiser_regist_model.dart';
import 'package:poom/screens/home_specific_screen.dart';
import 'package:poom/services/fundraiser_api.dart';
import 'package:poom/utils/metamask_util.dart';
import 'package:poom/widgets/loading/loading_widget.dart';

class RegistAfterScreen extends StatefulWidget {
  final File representImage;
  final File nftImage;
  final List<File> dogImages;
  FundraiserRegistModel dogRegistInfo;

  RegistAfterScreen({
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
    String walletAddressInstance = await MetamaskUtil.getMemberAddress();

    if (walletAddressInstance == '') {
      Navigator.pop(context);
      const snackBar = SnackBar(
        content: Text(
          '메타마스크에서 지갑 주소를 가져올 수 없습니다.',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    //메타마스크에서 지갑 주소 가져오기
    widget.dogRegistInfo.shelterEthWalletAddress =
        walletAddressInstance.toLowerCase();

    print("지갑주소>>>>>>> ${widget.dogRegistInfo.shelterEthWalletAddress}");

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
