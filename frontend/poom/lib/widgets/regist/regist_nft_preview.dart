import 'package:flutter/material.dart';
import 'package:poom/widgets/loading/loading_widget.dart';

class RegistNftPreview extends StatelessWidget {
  const RegistNftPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const Loading(
      title: 'NFT 생성 중',
      description: '등록하신 사진으로 \n AI가 NFT를 만들고 있어멍!',
    );
  }
}
