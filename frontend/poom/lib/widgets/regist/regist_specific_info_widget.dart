import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poom/widgets/regist/regist_input_form_widget.dart';

class RegistSpecificInfo extends StatefulWidget {
  final List<File> dogPhotoList;
  final void Function() pickDogPhotoImage;
  final void Function(int) deleteDogPhotoImage;
  final void Function() doRegist;

  const RegistSpecificInfo({
    super.key,
    required this.dogPhotoList,
    required this.pickDogPhotoImage,
    required this.deleteDogPhotoImage,
    required this.doRegist,
  });

  static Color inputBackground = const Color(0xFFD9D9D9).withOpacity(0.15);
  static const Color textColor = Color(0xFF333333);
  static const Color textSecondaryColor = Color(0xFF666666);

  @override
  State<RegistSpecificInfo> createState() => _RegistSpecificInfoState();
}

class _RegistSpecificInfoState extends State<RegistSpecificInfo> {
  int _dogGender = 0; //0: 암컷, 1: 수컷
  bool _ageIsEstimated = false;

  DateTime _endDate = DateTime.now().add(const Duration(days: 3));

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
            SizedBox(
              height: 114,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.dogPhotoList.length + 1, //사진 추가 컨테이너까지 포함
                itemBuilder: (BuildContext context, int index) {
                  if (index == widget.dogPhotoList.length) {
                    if (index == 4) return null;
                    return GestureDetector(
                      onTap: widget.pickDogPhotoImage,
                      child: Container(
                        height: 114,
                        width: 114,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
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
                              '사진 등록',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: RegistSpecificInfo.textSecondaryColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  return SizedBox(
                    width: 114,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: FileImage(widget.dogPhotoList[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () => widget.deleteDogPhotoImage(index),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  )),
                              child: const Icon(
                                Icons.close_outlined,
                                size: 20,
                                color: Color.fromARGB(176, 255, 255, 255),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 10),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Checkbox(
                    value: _ageIsEstimated,
                    onChanged: ((value) {
                      setState(() {
                        _ageIsEstimated = value!;
                      });
                    }),
                    activeColor: Theme.of(context).primaryColor,
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: 0),
                  ),
                ),
                const Text(
                  '추정',
                  style: TextStyle(
                    color: RegistSpecificInfo.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            ),
            const Title(title: '성별'),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: RadioListTile(
                    title: const Text('암컷'),
                    value: 0,
                    groupValue: _dogGender,
                    onChanged: (value) {
                      setState(() {
                        _dogGender = value!;
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
                    groupValue: _dogGender,
                    onChanged: (value) {
                      setState(() {
                        _dogGender = value!;
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
            const Title(
              title: '후원 마감',
            ),
            const Description(
                description: '지금으로부터 최소 3일 이후, 최대 3달 이내로 설정할 수 있어요!'),
            TextButton(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  // initialDate: DateTime.now().add(const Duration(days: 3)),
                  initialDate: _endDate,
                  firstDate: DateTime.now().add(const Duration(days: 3)),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                );
                if (selectedDate != null) {
                  setState(() {
                    _endDate = selectedDate;
                  });
                }
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
              ),
              child: Text(
                '${_endDate.year}.${_endDate.month.toString().padLeft(2, '0')}.${_endDate.day.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  color: RegistSpecificInfo.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            //------------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: GestureDetector(
                onTap: widget.doRegist,
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
