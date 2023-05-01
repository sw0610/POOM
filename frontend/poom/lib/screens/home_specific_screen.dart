import 'package:flutter/material.dart';
import 'package:poom/widgets/home/home_specific_supporter.dart';

class DogSpecificScreen extends StatelessWidget {
  const DogSpecificScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
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
              Stack(
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 312 / 269,
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        height: 269,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 20,
                                spreadRadius: 5,
                                color:
                                    const Color(0xFF000000).withOpacity(0.25),
                              )
                            ]),
                        child: Image.network(
                          'https://image.dongascience.com/Photo/2020/03/5bddba7b6574b95d37b6079c199d7101.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRm5q9thkNI7sXmH0ysGnn4_ugIwQxgoec3WQ&usqp=CAU',
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '뭉이',
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
                        child: const Row(
                          children: [
                            Text(
                              '용인시 보호소',
                              style: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 14,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: Color(0xFF666666),
                              size: 14,
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 85,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF4E6),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(''),
                    Column(
                      children: [
                        SummaryTitle(text: '후원 마감'),
                        SummaryValue(value: '23.01.01'),
                        SummaryValue(value: '12:59'),
                      ],
                    ),
                    DivideLine(),
                    Column(
                      children: [
                        SummaryTitle(text: '현재 모금액'),
                        SummaryValue(value: '0.562'),
                      ],
                    ),
                    DivideLine(),
                    Column(
                      children: [
                        SummaryTitle(text: '목표액'),
                        SummaryValue(value: '1.111'),
                      ],
                    ),
                    Text(''),
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
              const DogInfo(
                title: '보호소 주소',
                value: '경기도 용인시 수지구 무슨대로 66',
              ),
              const DogInfo(
                title: '성별',
                value: '수컷',
              ),
              const DogInfo(
                title: '나이',
                value: '8세 추정',
              ),
              const DogInfo(
                title: '특징',
                value:
                    '가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하',
              ),
              const Title(
                text: '후원자 목록',
              ),
              const Supporter(
                nickname: '닉네임',
                imgPath:
                    'https://img.segye.com/content/image/2020/07/01/20200701515451.JPG',
                amount: 3.3,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width - 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {},
          elevation: 8,
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
