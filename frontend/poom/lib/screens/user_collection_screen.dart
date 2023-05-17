import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poom/services/nft_api.dart';
import 'package:poom/widgets/collection/collection_header.dart';
import 'package:shimmer/shimmer.dart';

class UserCollectionScreen extends StatefulWidget {
  final String memberId;
  const UserCollectionScreen({
    super.key,
    required this.memberId,
  });

  static const Color _textColor = Color(0xFF333333);
  static const _primaryColor = Color(0xFFFF8E01);

  @override
  State<UserCollectionScreen> createState() => _UserCollectionScreenState();
}

class _UserCollectionScreenState extends State<UserCollectionScreen> {
  bool _isGrid = false;
  final bool _isOwner = false;
  bool _isDialogOpen = false;
  final imagePicker = ImagePicker();
  late Future<Map<String, dynamic>> result;
  List<String> nftList = [];
  bool hasMore = false;

  @override
  void initState() {
    super.initState();
    result = NftApiService().getAnotherUserNFTList(context, 0, widget.memberId);
  }

  // 다이얼로그 안내
  Future<void> showCustomDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          elevation: 1,
          title: const Text(
            "NFT 컬렉션 공유",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            "인스타그램을 먼저 설치해주세요.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          buttonPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          actions: <Widget>[
            Container(
              decoration: const BoxDecoration(
                color: UserCollectionScreen._primaryColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: 42,
              child: TextButton(
                child: const Text(
                  '확인',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  _isDialogOpen = false;
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: UserCollectionScreen._textColor,
          shadowColor: const Color(0xFFE4E4E4),
          centerTitle: true,
          elevation: 1,
          title: const Text(
            "NFT 컬렉션",
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
        child: FutureBuilder(
          future: result,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              hasMore = snapshot.data!["hasMore"];
              var nickname = snapshot.data!["nickname"];
              var nftCount = snapshot.data!["nftCount"];
              var nftImgUrls = snapshot.data!["nftImgUrls"];
              if (nftCount == 0) {
                return const Center(
                  child: Text(
                    "아직 발급한 NFT가 없어요!",
                    style: TextStyle(
                      color: Color(0xFF333333),
                    ),
                  ),
                );
              }
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CollectionHeader(
                          nickName: nickname, totalCount: nftCount),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isGrid = !_isGrid;
                          });
                        },
                        child: Icon(_isGrid
                            ? Icons.view_agenda
                            : Icons.grid_view_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _isGrid ? 2 : 1,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 5,
                        childAspectRatio: _isGrid | !_isOwner ? 1 : 1 / 1.32,
                      ),
                      itemCount: nftCount,
                      itemBuilder: (BuildContext context, int index) {
                        return CachedNetworkImage(
                          imageUrl: nftImgUrls[index],
                          width: MediaQuery.of(context).size.width,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(10.0), // 반경을 적용할 값
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade100,
                            highlightColor: Colors.white,
                            child: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        );
                      },
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
                    children: [
                      Container(
                        decoration: BoxDecoration(color: Colors.grey.shade400),
                        width: 160,
                        height: 20,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _isGrid ? 2 : 1,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 5,
                        childAspectRatio: 1,
                      ),
                      itemCount: 2,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
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
