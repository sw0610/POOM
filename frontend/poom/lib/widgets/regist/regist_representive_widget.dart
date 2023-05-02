import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegistRepresentive extends StatelessWidget {
  final VoidCallback nextPage;
  const RegistRepresentive({super.key, required this.nextPage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 20,
      ),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '대표 사진 등록',
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              '대표 사진은 NFT를 생성하는데에도 이용돼요!',
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              height: 114,
              width: 114,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Color(0xFFFFF4E6),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/icons/ic_camera.svg",
                    color: const Color(0xFF666666),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    '대표사진',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF666666),
                    ),
                  )
                ],
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            GestureDetector(
              onTap: nextPage,
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Theme.of(context).primaryColor,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'NFT 미리보기',
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
