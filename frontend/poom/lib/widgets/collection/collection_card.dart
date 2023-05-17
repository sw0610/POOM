import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poom/widgets/collection/cahced_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_share/social_share.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class CollectionCard extends StatefulWidget {
  const CollectionCard({
    super.key,
    required this.imageUrl,
    required this.isGrid,
    required this.isOwner,
    required this.isDialogOpen,
    required this.showCustomDialog,
    required this.setShowDialog,
  });

  final String imageUrl;
  final bool isGrid, isOwner, isDialogOpen;
  final Function showCustomDialog, setShowDialog;

  @override
  State<CollectionCard> createState() => _CollectionCardState();
}

class _CollectionCardState extends State<CollectionCard> {
  static const _appId = "542113181199892";

  Future<bool?> fileFromImageUrl(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File(path.join(documentDirectory.path, 'img_my_nft.png'));
    file.writeAsBytesSync(response.bodyBytes);

    // 인스타그램 스토리 공유
    var result = await SocialShare.shareInstagramStory(
            appId: _appId, imagePath: file.path)
        .then((value) {
      // 인스타그램 설치 여부에 따른 처리
      return value == "error" ? false : true;
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        child: Column(
          children: [
            Stack(
              children: [
                CachedImage(
                  imageUrl: widget.imageUrl,
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade100.withOpacity(0.5),
                    highlightColor: Colors.white,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            widget.isGrid & !widget.isOwner
                ? const SizedBox()
                : SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: GestureDetector(
                      onTap: () {
                        fileFromImageUrl(widget.imageUrl).then((result) {
                          if (result == false && widget.isDialogOpen == false) {
                            widget.setShowDialog(true);
                            widget.showCustomDialog(context);
                          }
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 32,
                          ),
                          SvgPicture.asset(
                            "assets/icons/ic _instagram.svg",
                            width: 24,
                            height: 24,
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
  }
}
