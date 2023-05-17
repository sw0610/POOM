import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poom/models/home/fundraiser_regist_model.dart';
import 'package:poom/widgets/regist/regist_input_form_widget.dart';
import 'package:intl/intl.dart';

class RegistSpecificInfo extends StatefulWidget {
  final List<File> dogPhotoList;
  final void Function() pickDogPhotoImage;
  final void Function(int) deleteDogPhotoImage;
  final void Function(FundraiserRegistModel) updateInfo;

  const RegistSpecificInfo({
    super.key,
    required this.dogPhotoList,
    required this.pickDogPhotoImage,
    required this.deleteDogPhotoImage,
    required this.updateInfo,
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
  late String _dogAge;
  late String _dogFeature;
  late String _dogName;

  // late String _shelterEthWalletAddress;
  final String _shelterEthWalletAddress =
      '0xb890800CA5f2b802758FC30AE1f2b3663796331A';
  late String _targetAmount;

  DateTime _endDate = DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
      .format(DateTime.now().add(const Duration(days: 3))));

  final formKey = GlobalKey<FormState>();

  void makeFundraiserModel() {
    final instance = FundraiserRegistModel(
      ageIsEstimated: _ageIsEstimated,
      dogAge: int.parse(_dogAge),
      dogGender: _dogGender,
      dogFeature: _dogFeature,
      dogName: _dogName,
      shelterEthWalletAddress: _shelterEthWalletAddress,
      endDate: _endDate,
      targetAmount: double.parse(_targetAmount),
    );
    widget.updateInfo(instance);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 다른 곳을 터치하면 포커스 해제 및 키보드 내리기
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Title(title: '강아지 사진'),
                      Description(
                        description: '(최소 1장, 최대 4장)',
                      ),
                    ],
                  ),
                ],
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
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                ),
              ),
              Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RegistInputForm(
                        title: '강아지 이름',
                        placeholder: '강아지의 이름을 입력하세요.',
                        onSaved: (val) {
                          setState(() {
                            _dogName = val;
                          });
                        },
                        validator: (val) {
                          if (val.isEmpty) {
                            return '필수 입력 값입니다.';
                          }
                          // 정규 표현식을 사용하여 영어와 한글만 허용하는 검증
                          RegExp regex = RegExp(r'^[a-zA-Zㄱ-ㅎ가-힣]+$');
                          if (!regex.hasMatch(val)) {
                            return '영어와 한글만 입력할 수 있습니다.';
                          }
                          return null;
                        },
                      ),
                      RegistInputForm(
                        title: '강아지 나이',
                        placeholder: '강아지의 나이를 입력하세요.',
                        isOnlyNum: true,
                        onSaved: (val) {
                          setState(() {
                            _dogAge = val;
                          });
                        },
                        validator: (val) {
                          if (val.isEmpty) {
                            return '필수 입력 값입니다.';
                          }
                          final number = int.tryParse(val);
                          if (number == null || number <= 0) {
                            return '나이를 정확히 입력해주세요.';
                          }
                          final specialChars = RegExp(r'[!@#$%^&*(),?":{}|<>]');
                          if (specialChars.hasMatch(val)) {
                            return '특수문자를 포함할 수 없습니다.';
                          }
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
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: 0),
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
                        onSaved: (val) {
                          setState(() {
                            _dogFeature = val;
                          });
                        },
                        validator: (val) {
                          if (val.isEmpty) {
                            return '필수 입력 값입니다.';
                          }
                          return null;
                        },
                      ),
                      RegistInputForm(
                        title: '목표 후원 금액',
                        placeholder: '1.000',
                        isOnlyNum: true,
                        isPositionedRight: true,
                        isHasSuffix: true,
                        onSaved: (val) {
                          _targetAmount = val;
                        },
                        validator: (val) {
                          if (val.isEmpty) {
                            return '필수 입력 값입니다.';
                          }
                          final number = double.tryParse(val);
                          if (number == null || number <= 0) {
                            return '0.123의 형태로 입력해주세요.';
                          }
                          final dotCount = val.split('.').length - 1;
                          if (dotCount > 1) {
                            return '소수점은 하나 이하로 입력해주세요';
                          }
                          final specialChars = RegExp(r'[!@#$%^&*(),?":{}|<>]');
                          if (specialChars.hasMatch(val)) {
                            return '특수문자를 포함할 수 없습니다';
                          }
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
                            firstDate:
                                DateTime.now().add(const Duration(days: 3)),
                            lastDate:
                                DateTime.now().add(const Duration(days: 90)),
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                          );
                          if (selectedDate != null) {
                            setState(() {
                              _endDate = selectedDate;
                            });
                          }
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.zero),
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
                    ],
                  )),

              //------------------------------------------------------------------
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // border radius 설정
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate() &&
                        widget.dogPhotoList.isNotEmpty) {
                      formKey.currentState!.save();
                      makeFundraiserModel();
                    } else {
                      const snackBar = SnackBar(
                        content: Text(
                          '모든 내용을 정확히 입력해주세요.',
                          style: TextStyle(color: Colors.white),
                        ),
                        duration: Duration(seconds: 3),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
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
            ],
          ),
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
