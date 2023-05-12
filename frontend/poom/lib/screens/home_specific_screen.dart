import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poom/models/home/fundraiser_specific_model.dart';
import 'package:poom/models/home/fundraiser_specific_sponsor_model.dart';
import 'package:poom/screens/donate_screen.dart';
import 'package:poom/services/home_api.dart';
import 'package:poom/widgets/home/home_specific_supporter.dart';

class DogSpecificScreen extends StatelessWidget {
  final int fundraiserId;
  final Future<FundraiserSpecificModel> specificInfo;
  final BuildContext context;

  DogSpecificScreen({
    super.key,
    required this.fundraiserId,
    required this.context,
  }) : specificInfo = HomeApi.getSpecificFundraiser(
          fundraiserId: fundraiserId,
          context: context,
        );

  @override
  Widget build(BuildContext context) {
    void goDonateScreen() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DonateScreen(),
          fullscreenDialog: true,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: const Color(0xFF333333),
        elevation: 1,
        centerTitle: true,
        title: const Text(
          '보호견 상세 조회',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: FutureBuilder(
        future: specificInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 30,
                  left: 30,
                  top: 24,
                  bottom: 100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data!.dogName,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Text(
                                    snapshot.data!.shelterName,
                                    style: const TextStyle(
                                      color: Color(0xFF666666),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right_rounded,
                                    color: Color(0xFF666666),
                                    size: 14,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                          clipBehavior: Clip.antiAlias,
                          width: 46,
                          height: 46,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Image.network(
                            snapshot.data!.nftImgUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 85,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF4E6),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(''),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SummaryTitle(text: '후원 마감'),
                              SummaryValue(value: snapshot.data!.endDate),
                            ],
                          ),
                          const DivideLine(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SummaryTitle(text: '현재 모금액'),
                              SummaryValue(
                                  value:
                                      snapshot.data!.currentAmount.toString()),
                            ],
                          ),
                          const DivideLine(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SummaryTitle(text: '목표액'),
                              SummaryValue(
                                  value:
                                      snapshot.data!.targetAmount.toString()),
                            ],
                          ),
                          const Text(''),
                        ],
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '단위: eth',
                          style: TextStyle(
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                    const Title(text: '보호견 정보'),
                    DogInfo(
                      title: '보호소 주소',
                      value: snapshot.data!.shelterAddress,
                    ),
                    DogInfo(
                      title: '성별',
                      value: snapshot.data!.dogGender == 0 ? '암컷' : '수컷',
                    ),
                    DogInfo(
                      title: '나이',
                      value: snapshot.data!.ageIsEstimated
                          ? '${snapshot.data!.dogAge}세'
                          : '${snapshot.data!.dogAge}세 추정',
                    ),
                    DogInfo(
                      title: '특징',
                      value: snapshot.data!.dogFeature,
                    ),
                    const Title(
                      text: '후원자 목록',
                    ),
                    if (snapshot.data!.donations.isNotEmpty)
                      for (FundraiserSpecificSponsorModel supporter
                          in snapshot.data!.donations)
                        Supporter(
                          nickname: supporter.nickname,
                          imgPath: supporter.profileImgUrl,
                          amount: supporter.donationAmount,
                        ),
                    if (snapshot.data!.donations.isEmpty)
                      const Center(
                          child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Text('후원자 목록이 없습니다.'),
                        ],
                      )),
                  ],
                ),
              ),
            );
          }
          return Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ));
        },
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width - 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: goDonateScreen,
          elevation: 8,
          icon: SvgPicture.asset(
            'assets/icons/ic_metamask_color.svg',
            height: 12.0,
          ),
          label: const Text(
            "Metamask로 후원하기",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

//보호견 정보 한 줄
class DogInfo extends StatelessWidget {
  final String title;
  final String value;

  const DogInfo({
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
                width: 80,
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

//보호견 정보, 후원자 목록에 사용되는 타이틀 속성
class Title extends StatelessWidget {
  final String text;

  const Title({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 24,
        ),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

//후원 마감, 현재 모금액, 목표액에 쓰이는 value 스타일
class SummaryValue extends StatelessWidget {
  final String value;

  const SummaryValue({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: const TextStyle(
        color: Color(0xFF333333),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

//후원 마감, 현재 모금액, 목표액에 쓰이는 제목 스타일
class SummaryTitle extends StatelessWidget {
  final String text;

  const SummaryTitle({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF666666),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: 7,
        ),
      ],
    );
  }
}

//후원 마감, 현재모금액, 목표액을 나누는 구분선
class DivideLine extends StatelessWidget {
  const DivideLine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.7,
      child: Container(
        width: 1,
        decoration: const BoxDecoration(
          color: Color(0xFFE5E4E9),
        ),
      ),
    );
  }
}
