import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poom/widgets/loading/loading_widget.dart';

class RegistNftPreview extends StatefulWidget {
  final VoidCallback prevPage;
  final VoidCallback nextPage;
  File? representImage;
  File? nftImage;

  RegistNftPreview({
    super.key,
    required this.prevPage,
    required this.nextPage,
    this.nftImage,
    this.representImage,
  });

  @override
  State<RegistNftPreview> createState() => _RegistNftPreviewState();
}

class _RegistNftPreviewState extends State<RegistNftPreview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: widget.nftImage == null
          ? const LoadingWidget(
              title: 'NFT 생성 중',
              description: '등록하신 사진으로 \n AI가 NFT를 만들고 있어멍!',
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'NFT 미리보기',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(
                    height: 55,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(widget.nftImage!),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8,
                              color: const Color(0xFF000000).withOpacity(0.08),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonStyle(
                        svg: 'assets/icons/ic_gallery.svg',
                        buttonTitle: '사진 변경',
                        doFunction: widget.prevPage,
                      ),
                    ],
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  GestureDetector(
                    onTap: widget.nextPage,
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '다음',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class ButtonStyle extends StatelessWidget {
  final String svg, buttonTitle;
  final VoidCallback doFunction;

  const ButtonStyle({
    super.key,
    required this.svg,
    required this.buttonTitle,
    required this.doFunction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: doFunction,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 62,
        decoration: const BoxDecoration(
          color: Color(0xFFF9F9F9),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svg,
              color: const Color(0xFF333333),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              buttonTitle,
              style: const TextStyle(
                color: Color(0xFF333333),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
