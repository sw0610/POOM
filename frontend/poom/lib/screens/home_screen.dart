import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:poom/screens/regist_screen.dart';
import 'package:poom/services/home_api.dart';
import 'package:poom/services/member_api.dart';
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
  bool _isClosed = false;
  String? _selectedSortType;
  bool _hasMore = false;
  List<dynamic>? fundraiserList;
  int _page = 0;
  static const int SIZE = 10;

  //무한스크롤 감지 컨트롤러
  final ScrollController _scrollController = ScrollController();

  //현재 로그인한 유저의 닉네임 가져오기
  void getNicknameAndIsShelter() async {
    await MemberApi.getMemberInfo(context);
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
    print('isClosed: $_isClosed \n page: $_page \n size: $SIZE');
    List<dynamic> hasMoreAndfundraiserList = await HomeApi.getFundraiserList(
      context: context,
      isClosed: _isClosed,
      page: _page,
      size: SIZE,
    );
    if (mounted) {
      setState(() {
        if (hasMoreAndfundraiserList.isNotEmpty) {
          _hasMore = hasMoreAndfundraiserList[0];
          if (fundraiserList == null) {
            fundraiserList = hasMoreAndfundraiserList[1];
          } else {
            fundraiserList = fundraiserList! + hasMoreAndfundraiserList[1];
          }
        }
      });
    }
  }

  @override
  void dispose() {
    // 스크롤 이벤트 리스너 해제
    _scrollController.dispose();
    super.dispose();
  }

  // 스크롤 이벤트 핸들러
  void _onScroll() {
    // 스크롤이 끝에 도달한 경우
    if (_hasMore && _scrollController.position.extentAfter < 10) {
      _page += 1;
      getFundraiserList();
    }
  }

  //access token 보려고 임시로
  static const storage = FlutterSecureStorage();
  void getAccessToken() async {
    var accesstoken = await storage.read(key: 'accesstoken');
    var refreshtoken = await storage.read(key: 'refreshtoken');
    print('홈화면 accesstoken: $accesstoken');
    print('홈화면 refreshtoken: $refreshtoken');
  }

  @override
  void initState() {
    super.initState();

    getNicknameAndIsShelter();
    setState(() {
      _selectedSortType = _sortType[0];
    });
    getFundraiserList();
    // 스크롤 이벤트 리스너 등록
    _scrollController.addListener(_onScroll);
    getAccessToken(); //access token 보려고 임시로
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
          controller: _scrollController,
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
                            _page = 0;
                            setState(() {
                              if (value == "모집 중") {
                                _isClosed = false;
                              } else {
                                _isClosed = true;
                              }
                            });
                            fundraiserList = null;
                            getFundraiserList();
                          });
                        })
                  ],
                ),
              );
            }
            return fundraiserList == null
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: Container(
                      height: 120,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                : fundraiserList!.isEmpty
                    ? Padding(
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
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                        ),
                        child: HomeDogCard(dogInfo: fundraiserList![index - 2]),
                      );
          },
          itemCount: fundraiserList == null
              ? 3
              : fundraiserList!.isEmpty
                  ? 3
                  : fundraiserList!.length + 2,
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
                  height: 300,
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
