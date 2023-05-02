import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  static const Color _textColor = Color(0xFF333333);

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  bool _isGrid = false;
  final bool _isOwner = false;

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
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      child: Column(
                        children: [
                          Image.network(
                            "https://img.freepik.com/premium-vector/cute-coton-de-tulear-puppy-cartoon-vector-illustration_42750-1173.jpg",
                            width: MediaQuery.of(context).size.width,
                          ),
                          _isGrid & !_isOwner
                              ? const SizedBox()
                              : SizedBox(
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
