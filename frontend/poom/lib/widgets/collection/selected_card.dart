import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class SelectedCard extends StatefulWidget {
  final String imageUrl;
  const SelectedCard({
    super.key,
    required this.imageUrl,
  });

  @override
  State<SelectedCard> createState() => _SelectedCardState();
}

class _SelectedCardState extends State<SelectedCard>
    with SingleTickerProviderStateMixin {
  double dragPosition = 0;
  bool isFront = true;
  late AnimationController controller;
  late Animation<double> animation;
  void setImageSide() {
    if (dragPosition <= 90 || dragPosition >= 270) {
      isFront = true;
    } else {
      isFront = false;
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(microseconds: 500),
      vsync: this,
    );

    controller.addListener(() {
      setState(() {
        dragPosition = animation.value;
        setImageSide();
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const pi = 3.14;
    final angle = dragPosition / 180 * pi;
    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateY(angle);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
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
      body: Stack(clipBehavior: Clip.hardEdge, children: [
        Lottie.network(
            "https://assets3.lottiefiles.com/datafiles/gESGR32gqg7VYQX/data.json",
            fit: BoxFit.cover,
            width: 500),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: GestureDetector(
              onHorizontalDragUpdate: (detail) => setState(() {
                dragPosition -= detail.delta.dx;
                dragPosition %= 360;
                setImageSide();
              }),
              onHorizontalDragEnd: (detail) {
                double end = isFront ? (dragPosition > 180 ? 360 : 0) : 180;
                animation = Tween<double>(begin: dragPosition, end: end)
                    .animate(controller);
                controller.forward(from: 0);
              },
              child: Transform(
                transform: transform,
                alignment: Alignment.center,
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.imageUrl,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Shimmer.fromColors(
                          baseColor: Colors.blue.shade200.withOpacity(0.1),
                          highlightColor: Colors.white,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
