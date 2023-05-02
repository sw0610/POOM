import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegistSpecificInfo extends StatelessWidget {
  const RegistSpecificInfo({super.key});

  // static const Color inputBackground = Color(0xFFF9F9F9);
  static const Color inputBackground = Color.fromARGB(255, 196, 196, 196);
  static const Color textColor = Color(0xFF333333);
  static const Color textSecondaryColor = Color(0xFF666666);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '보호견 정보 등록',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: textColor,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            '후원받을 보호견의 정보를 등록하세요!',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Title(title: '강아지 사진'),
              Description(
                description: '(최대 4장)',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 114,
            width: 114,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: inputBackground,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/ic_camera.svg",
                  color: textSecondaryColor,
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  '대표사진',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: textSecondaryColor,
                  ),
                )
              ],
            ),
          ),
          const Title(
            title: '강아지 이름',
          ),
          const Title(
            title: '강아지 나이',
          ),
          const Title(
            title: '성별',
          ),
          const Title(
            title: '특징',
          ),
          const Description(description: '상세하게 작성할 수록 후원받을 확률이 높아져요!'),
          const Title(
            title: '목표 후원 금액',
          ),
          const Title(
            title: '후원 마감',
          ),
          const Description(description: '지금으로부터 최소 3일 이후로 설정할 수 있어요!'),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: GestureDetector(
              onTap: () {
                print('등록 버튼 클릭');
              },
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
                    '등록',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Description extends StatelessWidget {
  static const Color textSecondaryColor = Color(0xFF666666);

  final String description;

  const Description({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(
        description,
        style: const TextStyle(
          color: textSecondaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class Title extends StatelessWidget {
  static const Color textColor = Color(0xFF333333);
  static const Color textSecondaryColor = Color(0xFF666666);

  final String title;
  const Title({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, right: 5),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
