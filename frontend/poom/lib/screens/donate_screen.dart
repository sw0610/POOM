import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poom/services/eth_per_krw_api.dart';
import 'package:poom/utils/metamask_util.dart';
import 'package:poom/widgets/home/dialog_button.dart';

class DonateScreen extends StatefulWidget {
  final String memberId;
  final int fundraiserId;
  final double remainAmount;

  const DonateScreen({
    super.key,
    required this.memberId,
    required this.fundraiserId,
    required this.remainAmount,
  });

  static const Color _textColor = Color(0xFF333333);
  static const Color _secondaryTextColor = Color(0xFF666666);

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  double ethPerKRW = 0.0; //초기값은 string -> api 받아오면 double 타입으로 변경
  String krw = '';

  final dialogMsg = {
    -1: ["잔고부족", "지갑 잔고를 확인해주세요!"],
    0: ["후원오류", "잠시 후 다시 후원해주세요!"],
    1: ["후원성공", "후원 내역은 나의 프로필에서 확인할 수 있어요:)"],
    2: ["메타마스크 미설치", "메타마스크를 먼저 설치해주세요!"],
  };

  final String _shelterName = "용인시 보호소";
  final String _dogName = "쿵이";
  String _inputEth = '';
  bool isEnabled = false;

  // ethPerKRW = EthPerKrwApi.getEthPerKrw();

  Future<void> _fetchEthPerKrw() async {
    double value = await EthPerKrwApi.getEthPerKrw();
    setState(() {
      ethPerKRW = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchEthPerKrw();
  }

  void _updateInputEth(String num) {
    setState(() {
      if (num == '<') {
        if (_inputEth != '') {
          String newEth = _inputEth.substring(0, _inputEth.length - 1);
          _inputEth = newEth;
          if (newEth == '') {
            krw = '';
          } else {
            int intKrw = (double.parse(_inputEth) / ethPerKRW * 1000).toInt();
            krw = NumberFormat('#,###').format(intKrw);
          }
        }
      } else if (num == '.') {
        if (_inputEth.contains('.')) {
          return;
        } else {
          _inputEth += num;
          int intKrw = (double.parse(_inputEth) / ethPerKRW * 1000).toInt();
          krw = NumberFormat('#,###').format(intKrw);
        }
      } else {
        _inputEth += num;
        int intKrw = (double.parse(_inputEth) / ethPerKRW * 1000).toInt();
        krw = NumberFormat('#,###').format(intKrw);
      }

      if (_inputEth != '' && double.parse(_inputEth) != 0) {
        isEnabled = true;
      } else {
        isEnabled = false;
      }

      if (_inputEth != '' && double.parse(_inputEth) >= widget.remainAmount) {
        _inputEth = widget.remainAmount.toString();
      }
    });
  }

  Future<String?> _doDonate(BuildContext context) async {
    double ethAmount = double.parse(_inputEth);

    int result = await MetamaskUtil.handleGenerateSupport(
        widget.fundraiserId, ethAmount);
    return handleShowDialog(result);
  }

  Future<String?> handleShowDialog(int result) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        elevation: 1,
        title: Text(
          dialogMsg[result]!.first,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          textAlign: TextAlign.center,
          dialogMsg[result]!.last,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        buttonPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DialogButton(
                result: result,
                fundraiserId: widget.fundraiserId,
              )
            ],
          ),
        ],
      ),
    );
  }

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
                    Text(
                      '$krw원',
                      style: const TextStyle(
                        color: DonateScreen._secondaryTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              const Expanded(child: SizedBox()),
              ElevatedButton(
                onPressed: isEnabled ? () => _doDonate(context) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  minimumSize: Size(MediaQuery.of(context).size.width, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Metamask로 후원하기',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              GridView.count(
                shrinkWrap: true,
                primary: false,
                childAspectRatio: 52 / 35,
                // padding: const EdgeInsets.all(20),
                crossAxisCount: 3,
                children: [
                  NumButton(
                    number: '1',
                    onPressed: () => _updateInputEth('1'),
                  ),
                  NumButton(
                    number: '2',
                    onPressed: () => _updateInputEth('2'),
                  ),
                  NumButton(
                    number: '3',
                    onPressed: () => _updateInputEth('3'),
                  ),
                  NumButton(
                    number: '4',
                    onPressed: () => _updateInputEth('4'),
                  ),
                  NumButton(
                    number: '5',
                    onPressed: () => _updateInputEth('5'),
                  ),
                  NumButton(
                    number: '6',
                    onPressed: () => _updateInputEth('6'),
                  ),
                  NumButton(
                    number: '7',
                    onPressed: () => _updateInputEth('7'),
                  ),
                  NumButton(
                    number: '8',
                    onPressed: () => _updateInputEth('8'),
                  ),
                  NumButton(
                    number: '9',
                    onPressed: () => _updateInputEth('9'),
                  ),
                  NumButton(
                    number: '.',
                    onPressed: () => _updateInputEth('.'),
                  ),
                  NumButton(
                    number: '0',
                    onPressed: () => _updateInputEth('0'),
                  ),
                  NumButton(
                    number: '<',
                    onPressed: () => _updateInputEth('<'),
                  ),
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
  final VoidCallback onPressed;

  const NumButton({
    super.key,
    required this.number,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
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
