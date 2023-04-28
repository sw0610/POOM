import 'package:flutter/material.dart';
import 'package:poom/widgets/main/card_widget/classification_text.dart';
import 'package:poom/widgets/main/card_widget/value_text.dart';

class HomeCardWidget extends StatelessWidget {
  const HomeCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 120,
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
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Image.network(
                        'https://image.dongascience.com/Photo/2020/03/5bddba7b6574b95d37b6079c199d7101.jpg',
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
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRm5q9thkNI7sXmH0ysGnn4_ugIwQxgoec3WQ&usqp=CAU',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Text(
                                '쿵이',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '♂',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              child: Text(
                                '인천광역시 보호소',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ClassificationText(classification: '후원 마감'),
                          ValueText(value: '23.01.01 23:42'),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ClassificationText(classification: '현재 모금액'),
                          ValueText(value: '12 MATIC'),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ClassificationText(classification: '목표액'),
                          ValueText(value: '30 MATIC'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
