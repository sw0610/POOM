import 'package:flutter/material.dart';
import 'package:poom/widgets/home/home_dog_card.dart';

class HomeScreen extends StatelessWidget {
  final String nickname = '유후';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0), // here the desired height
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 5),
                child: Container(
                  height: 26,
                  width: 26,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/img_logo.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                ),
              ),
              const Text(
                'POOM',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.add,
                  color: Color(0xFF333333),
                ),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 36,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$nickname 님,',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            '안녕하세멍!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              //강아지 넣을 것
                              height: 212,
                              width: 135,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/img_maindog.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(60, 0),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  height: 212,
                                  width: 212,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFBD898),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 64,
                                  right: 68,
                                  child: Container(
                                    height: 212,
                                    width: 212,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '도움이 필요해요!',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text('최신순'),
                ],
              ),
              const DogListCardWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
