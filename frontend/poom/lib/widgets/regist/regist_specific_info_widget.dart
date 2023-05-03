import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poom/widgets/regist/regist_input_form_widget.dart';

class RegistSpecificInfo extends StatefulWidget {
  const RegistSpecificInfo({super.key});

  // static const Color inputBackground = Color(0xFFF9F9F9);
  static const Color inputBackground = Color.fromARGB(255, 196, 196, 196);
  static const Color textColor = Color(0xFF333333);
  static const Color textSecondaryColor = Color(0xFF666666);

  @override
  State<RegistSpecificInfo> createState() => _RegistSpecificInfoState();
}

class _RegistSpecificInfoState extends State<RegistSpecificInfo> {
  int _gender = 0; //0: 암컷, 1: 수컷

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '보호견 정보 등록',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: RegistSpecificInfo.textColor,
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
                color: RegistSpecificInfo.textColor,
              ),
            ),
            Form(
              key: formKey,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Title(title: '강아지 사진'),
                      Description(
                        description: '(최대 4장)',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 114,
              width: 114,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: RegistSpecificInfo.inputBackground,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/icons/ic_camera.svg",
                    color: RegistSpecificInfo.textSecondaryColor,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    '대표사진',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: RegistSpecificInfo.textSecondaryColor,
                    ),
                  )
                ],
              ),
            ),
            RegistInputForm(
              title: '강아지 이름',
              placeholder: '강아지의 이름을 입력하세요.',
              onSaved: (val) {},
              validator: (val) {
                return null;
              },
            ),
            RegistInputForm(
              title: '강아지 나이',
              placeholder: '강아지의 나이를 입력하세요.',
              isOnlyNum: true,
              onSaved: (val) {},
              validator: (val) {
                return null;
              },
            ),
            const Title(title: '성별'),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: RadioListTile(
                    title: const Text('암컷'),
                    value: 0,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: RadioListTile(
                    title: const Text('수컷'),
                    value: 1,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),

            RegistInputForm(
              title: '특징',
              description: '상세하게 작성할 수록 후원받을 확률이 높아져요!',
              placeholder: '강아지의 특징을 입력하세요.',
              isTextarea: true,
              onSaved: (val) {},
              validator: (val) {
                return null;
              },
            ),
            RegistInputForm(
              title: '목표 후원 금액',
              placeholder: '1.000',
              isOnlyNum: true,
              isPositionedRight: true,
              isHasSuffix: true,
              onSaved: (val) {},
              validator: (val) {
                return null;
              },
            ),

            //------------------------------------------------------------------
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
