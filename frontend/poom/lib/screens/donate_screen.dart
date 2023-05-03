import 'package:flutter/material.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({super.key});

  static const Color _textColor = Color(0xFF333333);
  static const Color _secondaryTextColor = Color(0xFF666666);

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  double ethPerKRW = 0.00040;
  final String _shelterName = "용인시 보호소";
  final String _dogName = "쿵이";
  final String _inputEth = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: DonateScreen._textColor,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          '후원하기',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 24, left: 24, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 68,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                // color: Color(0xFFFFF4E6),
                color: Color(0xFFFFF4E6),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '💡현재 환율',
                      style: TextStyle(
                        color: DonateScreen._secondaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '1000 KRW = $ethPerKRW eth',
                      style: const TextStyle(
                        color: DonateScreen._textColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              _shelterName,
              style: const TextStyle(
                color: DonateScreen._secondaryTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text(
                  _dogName,
                  style: const TextStyle(
                    color: DonateScreen._textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  '에게',
                  style: TextStyle(
                    color: DonateScreen._textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            if (_inputEth == "")
              const Text(
                '얼마나 후원할까요?',
                style: TextStyle(
                  color: DonateScreen._secondaryTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
