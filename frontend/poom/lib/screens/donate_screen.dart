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
  final String _inputEth = "0.75";

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
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Padding(
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
              if (_inputEth != "")
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$_inputEth eth',
                      style: const TextStyle(
                        color: DonateScreen._textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text(
                      '7077원',
                      style: TextStyle(
                        color: DonateScreen._secondaryTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              const Expanded(child: SizedBox()),
              GestureDetector(
                onTap: () {
                  print('후원하기 버튼 클릭');
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'MetaMask로 후원',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              GridView.count(
                shrinkWrap: true,
                primary: false,
                childAspectRatio: 52 / 35,
                // padding: const EdgeInsets.all(20),
                crossAxisCount: 3,
                children: const [
                  NumButton(number: '1'),
                  NumButton(number: '2'),
                  NumButton(number: '3'),
                  NumButton(number: '4'),
                  NumButton(number: '5'),
                  NumButton(number: '6'),
                  NumButton(number: '7'),
                  NumButton(number: '8'),
                  NumButton(number: '9'),
                  NumButton(number: '.'),
                  NumButton(number: '0'),
                  NumButton(number: '<'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NumButton extends StatelessWidget {
  final String number;

  const NumButton({
    super.key,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        // backgroundColor: Colors.red,
        elevation: 0,
      ),
      child: Text(
        number,
        style: const TextStyle(
          color: Color(0xFF333333),
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
