import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_share/social_share.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  static const Color _textColor = Color(0xFF333333);

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  bool _isGrid = false;
  final bool _isOwner = false;
  final _appId = "542113181199892";
  final imagePicker = ImagePicker();

  // 이미지 URL -> File path
  void fileFromImageUrl(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File(join(documentDirectory.path, 'img_my_nft.png'));
    file.writeAsBytesSync(response.bodyBytes);

    // 인스타그램 스토리 공유
    SocialShare.shareInstagramStory(appId: _appId, imagePath: file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: CollectionScreen._textColor,
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text(
                      "나는야 강형욱",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: CollectionScreen._textColor,
                      ),
                    ),
                    Text(
                      "님의 품",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: CollectionScreen._textColor,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isGrid = !_isGrid;
                    });
                  },
                  child: Icon(
                      _isGrid ? Icons.view_agenda : Icons.grid_view_rounded),
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
                  childAspectRatio: _isGrid ? 1 : 1 / 1.32,
                ),
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  var testImageUrl =
                      "https://img.freepik.com/premium-vector/cute-coton-de-tulear-puppy-cartoon-vector-illustration_42750-1173.jpg";

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      child: Column(
                        children: [
                          CachedImage(
                            imageUrl: testImageUrl,
                          ),
                          _isGrid & !_isOwner
                              ? const SizedBox()
                              : GestureDetector(
                                  onTap: () {
                                    print("onTap()");
                                    fileFromImageUrl(testImageUrl);
                                  },
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 32,
                                        ),
                                        SvgPicture.asset(
                                          "assets/icons/ic _instagram.svg",
                                          width: 20,
                                          height: 20,
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        const Text(
                                          "공유",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
      ),
    );
  }
}

class CachedImage extends StatelessWidget {
  final String imageUrl;
  const CachedImage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: MediaQuery.of(context).size.width,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey.shade100,
        highlightColor: Colors.white,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12)),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double height = constraints.maxWidth;
              return Container(
                height: height,
              );
            },
          ),
        ),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
