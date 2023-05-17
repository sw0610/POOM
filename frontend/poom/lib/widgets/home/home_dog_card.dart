import 'package:flutter/material.dart';
import 'package:poom/models/home/home_dog_card_model.dart';
import 'package:poom/screens/home_specific_screen.dart';

class HomeDogCard extends StatelessWidget {
  final HomeDogCardModel dogInfo;

  const HomeDogCard({
    super.key,
    required this.dogInfo,
  });

  @override
  Widget build(BuildContext context) {
    //보호견 상세페이지로 이동
    void goDogSpecificScreen() {
      print('dogCard fundraiserId: ${dogInfo.fundraiserId}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DogSpecificScreen(
            fundraiserId: dogInfo.fundraiserId,
            context: context,
          ),
          fullscreenDialog: false,
        ),
      );
    }

    return GestureDetector(
      onTap: goDogSpecificScreen,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.black.withOpacity(0.08),
                ),
              ],
              color: Theme.of(context).colorScheme.background,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        width: 112,
                        height: 112,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Image.network(
                          dogInfo.mainImgUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Image.network(
                            dogInfo.nftImgUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(4),
                            ),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            child: Text(
                              dogInfo.shelterName,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              dogInfo.dogName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Color(0xFF333333),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              dogInfo.dogGender == 0 ? '♀' : '♂',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: dogInfo.dogGender == 0
                                    ? Colors.pink
                                    : Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const ClassificationText(classification: '후원 마감'),
                            ValueText(value: dogInfo.endDate),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const ClassificationText(classification: '현재 모금액'),
                            ValueText(
                                value:
                                    '${dogInfo.currentAmount.toString()} eth'),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const ClassificationText(classification: '목표액'),
                            ValueText(
                                value:
                                    '${dogInfo.targetAmount.toString()} eth'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class ValueText extends StatelessWidget {
  final String value;

  const ValueText({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: const TextStyle(
        color: Color(0xFF333333),
        fontSize: 14,
      ),
    );
  }
}

class ClassificationText extends StatelessWidget {
  final String classification;

  const ClassificationText({
    super.key,
    required this.classification,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 66,
      child: Text(
        classification,
        style: const TextStyle(
          color: Color(0xFF666666),
          fontSize: 12,
        ),
      ),
    );
  }
}
