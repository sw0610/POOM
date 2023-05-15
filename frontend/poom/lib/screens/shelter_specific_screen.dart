import 'package:flutter/material.dart';
import 'package:poom/models/home/shelter_info_model.dart';
import 'package:poom/services/home_api.dart';
import 'package:poom/widgets/shelter/kakao_map_widget.dart';

class ShelterInfoScreen extends StatelessWidget {
  final String shelterId;
  final Future<ShelterInfoModel> shelterInfo;
  final BuildContext context;

  ShelterInfoScreen({
    super.key,
    required this.shelterId,
    required this.context,
  }) : shelterInfo = HomeApi.getShelterInfo(
          context: context,
          shelterId: shelterId,
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: const Color(0xFF333333),
        elevation: 1,
        centerTitle: true,
        title: const Text(
          '보호소 정보',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: FutureBuilder(
        future: shelterInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '보호소 정보',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ShelterInfo(
                    title: '보호소명',
                    value: snapshot.data!.shelterName,
                  ),
                  ShelterInfo(
                    title: '전화번호',
                    value: snapshot.data!.shelterPhoneNumber,
                  ),
                  ShelterInfo(
                    title: '주소',
                    value: snapshot.data!.shelterAddress,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          width: 44,
                          child: Text(
                            '위치',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: KakaoMapWidget(
                          shelterAddress: snapshot.data!.shelterAddress,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        },
      ),
    );
  }
}

//보호견 정보 한 줄
class ShelterInfo extends StatelessWidget {
  final String title;
  final String value;

  const ShelterInfo({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                width: 44,
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
