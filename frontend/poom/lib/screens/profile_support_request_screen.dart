import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poom/screens/home_specific_screen.dart';
import 'package:poom/services/profile_api_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class SupportRequestScreen extends StatefulWidget {
  const SupportRequestScreen({super.key});
  static const _textColor = Color(0xFF333333);

  @override
  State<SupportRequestScreen> createState() => _SupportRequestScreenState();
}

class _SupportRequestScreenState extends State<SupportRequestScreen> {
  late Future<List<dynamic>> result;

  bool hasMore = false;
  int pageNum = 0;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<dynamic> list = [];
  @override
  void initState() {
    super.initState();
    result =
        ProfileApiService().getMySupportRequestList(context, pageNum, false);
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!hasMore) return;

    pageNum += 1;
    var moreData = await ProfileApiService()
        .getMySupportRequestList(context, pageNum, false);

    hasMore = moreData.first;
    for (int i = 0; i < moreData.last.length; i++) {
      list.add(moreData.last[i]);
    }
    _refreshController.loadComplete();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: SupportRequestScreen._textColor,
          elevation: 1,
          title: const Text(
            "후원 요청 목록",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: FutureBuilder(
          future: result,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              hasMore = snapshot.data!.first;
              var shelterName = snapshot.data![1];
              var fundraisers = snapshot.data!.last;

              list = fundraisers;
              if (fundraisers.length == 0) {
                return const Text("아직 등록한 후원 요청이 없어요!");
              }

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        shelterName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: SupportRequestScreen._textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: SmartRefresher(
                      onLoading: _onLoading,
                      onRefresh: _onRefresh,
                      controller: _refreshController,
                      enablePullDown: true,
                      enablePullUp: true,
                      child: ListView.builder(
                        itemCount: list.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          var current = list[index];
                          return Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFFF4F4F4),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: RequestItem(
                              fundraiserId: current.fundraiserId,
                              shelterName: current.shelterName ?? shelterName,
                              dogName: current.dogName,
                              dogGender: current.dogGender,
                              endDate: current.endDate,
                              currentAmount: current.currentAmount,
                              targetAmount: current.targetAmount,
                              mainImgUrl: current.mainImgUrl,
                              nftImgUrl: current.nftImgUrl,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade100,
              highlightColor: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 200,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFFF4F4F4),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                const SizedBox(
                                  width: 14,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: 100,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      width: 100,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      width: 100,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class RequestItem extends StatelessWidget {
  static const Color _textColor = Color(0xFF333333);
  int fundraiserId, dogGender;
  String dogName, mainImgUrl, nftImgUrl, shelterName, endDate;
  num currentAmount, targetAmount;

  RequestItem(
      {super.key,
      required this.fundraiserId,
      required this.dogGender,
      required this.dogName,
      required this.mainImgUrl,
      required this.nftImgUrl,
      required this.shelterName,
      required this.endDate,
      required this.currentAmount,
      required this.targetAmount});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DogSpecificScreen(
              context: context,
              fundraiserId: fundraiserId,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    imageUrl: mainImgUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      imageUrl: nftImgUrl,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 14,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      dogName,
                      style: const TextStyle(
                        color: _textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      dogGender == 0 ? '♀' : '♂',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: dogGender == 0 ? Colors.pink : Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      "후원 마감일",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      endDate,
                      style: const TextStyle(
                        color: _textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "현재 모금액",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      "$currentAmount eth",
                      style: const TextStyle(
                        color: _textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "목표 후원금",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      "$targetAmount eth",
                      style: const TextStyle(
                        color: _textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
