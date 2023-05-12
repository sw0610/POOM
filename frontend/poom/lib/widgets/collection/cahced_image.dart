import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
