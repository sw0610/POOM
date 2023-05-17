import 'package:flutter/material.dart';
import 'package:poom/models/profile/support_model.dart';
import 'package:poom/services/profile_api_service.dart';
import 'package:poom/widgets/profile/profile_support_item.dart';
import 'package:shimmer/shimmer.dart';

class ProfileSupportScreen extends StatefulWidget {
  const ProfileSupportScreen({super.key});

  @override
  State<ProfileSupportScreen> createState() => _ProfileSupportScreenState();
}

class _ProfileSupportScreenState extends State<ProfileSupportScreen> {
  static const _textColor = Color(0xFF333333);
  late Future<List<dynamic>> result;
  late List<SupportModel> supportList;

  @override
  void initState() {
    super.initState();
    result = ProfileApiService().getMySupportList(context, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: _textColor,
          elevation: 1,
          title: const Text(
            "나의 후원 내역",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 24,
        ),
        child: Column(
          children: [
            const Row(
              children: [
                Text(
                  "최근 후원 내역",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            Expanded(
              child: FutureBuilder(
                future: result,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var hasMore = snapshot.data!.first;
                    var supportList = snapshot.data!.last;

                    if (supportList.length == 0) {
                      return const Text("아직 후원한 내역이 없어요!");
                    }

                    return ListView.separated(
                      itemCount: supportList.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        var item = supportList[index];
                        return SupportItem(
                          donationId: item["donationId"],
                          fundraiserId: item["fundraiserId"],
                          dogName: item["dogName"],
                          donateDate: item["donateDate"],
                          donateAmount: item["donateAmount"],
                          isIssued: item["isIssued"],
                          nftImgUrl: item["nftImgUrl"],
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                    );
                  }

                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade100,
                    highlightColor: Colors.white,
                    child: ListView.separated(
                      itemCount: 10,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 92,
                          decoration: const BoxDecoration(),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade400,
                                        ),
                                        width: 68,
                                        height: 68,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                        Container(
                                          width: 40,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                        Container(
                                          width: 40,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 40,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
