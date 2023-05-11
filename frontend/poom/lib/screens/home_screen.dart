import 'package:flutter/material.dart';
import 'package:poom/screens/regist_screen.dart';
import 'package:poom/services/home_api.dart';
import 'package:poom/widgets/home/home_dog_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String nickname = '';
  bool isShelter = false;
  final _sortType = ['모집 중', '모집완료'];
  String? _selectedSortType;
  bool hasMore = false;
  List<dynamic> fundraiserList = [];

  //현재 로그인한 유저의 닉네임 가져오기
  void getNicknameAndIsShelter() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? prefNickname = pref.getString('nickname');
    bool? prefIsShelter = pref.getBool('isShelter');
    setState(() {
      nickname = prefNickname!;
      isShelter = prefIsShelter!;
    });
  }

  //후원 모집 목록 가져오기
  void getFundraiserList() async {
    List<dynamic> hasMoreAndfundraiserList = await HomeApi.getFundraiserList(
      context: context,
      isClosed: false,
      page: 0,
      size: 10,
    );
    setState(() {
      hasMore = hasMoreAndfundraiserList[0];
      fundraiserList = fundraiserList + hasMoreAndfundraiserList[1];
    });
  }

  @override
  void initState() {
    super.initState();
    getNicknameAndIsShelter();
    setState(() {
      _selectedSortType = _sortType[0];
    });
    getFundraiserList();
  }

  @override
  Widget build(BuildContext context) {
    void goRegistScreen() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegistScreen(),
          fullscreenDialog: true,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
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
            if (isShelter)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  onPressed: goRegistScreen,
                  icon: const Icon(
                    Icons.add,
                    color: Color(0xFF333333),
                  ),
                ),
              )
          ],
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemBuilder: (context, index) {
            //첫번째 자식요소
            if (index == 0) {
              return HomeIntroWidget(nickname: nickname);
            }
            //두번째 자식요소
            else if (index == 1) {
              return Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 30,
                  bottom: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      '도움이 필요해요!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    DropdownButton(
                        isDense: true,
                        alignment: Alignment.bottomRight,
                        underline: Container(
                          height: 0,
                        ),
                        value: _selectedSortType,
                        items: _sortType
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSortType = value;
                          });
                        })
                  ],
                ),
              );
            }
            return fundraiserList.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    child: HomeDogCard(dogInfo: fundraiserList[index - 2]),
                  )
                : Padding(
                    padding: const EdgeInsets.all(24),
                    child: Container(
                      height: 120,
                      alignment: Alignment.center,
                      child: const Text(
                        '도움이 필요한 보호견이 없어요',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
          },
          itemCount: fundraiserList.isNotEmpty ? fundraiserList.length + 2 : 3,
        ),
      ),
    );
  }
}

class HomeIntroWidget extends StatelessWidget {
  const HomeIntroWidget({
    super.key,
    required this.nickname,
  });

  final String nickname;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24, right: 24, left: 24),
            child: Column(
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
          ),
          ClipRect(
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 310,
                ),
                Positioned(
                  bottom: 0,
                  right: -30,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    height: MediaQuery.of(context).size.width * 0.55,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(2000),
                      ),
                      color: Color(0xFFFBD898),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 70,
                  right: 50,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    height: MediaQuery.of(context).size.width * 0.55,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(2000),
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 30,
                  child: Image.asset(
                    'assets/images/img_maindog.png',
                    height: 310 * 0.8,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
