import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:poom/services/nft_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/web3dart.dart';

class MetamaskUtil {
  static const apiUrl =
      "https://sepolia.infura.io/v3/0be8b78f1cad416a80f5d523b264e437";
  static final WalletConnect _connector = WalletConnect(
    bridge: 'https://bridge.walletconnect.org',
    clientMeta: const PeerMeta(
      name: 'POOM',
      description: 'An app for converting pictures to NFT',
      url: 'https://walletconnect.org',
      icons: [
        'https://velog.velcdn.com/images/taebong1012/profile/64d88125-3ac8-461d-8537-40dad38b0097/image.png'
      ],
    ),
  );
  static late final SessionStatus _session;
  static late final String _senderAddress, _uri;
  static late final bool isAppInstalled;

  static WalletConnect getConnector() {
    return _connector;
  }

  // 메타마스크 연결 여부 확인
  static Future<bool> isConnected() async {
    if (!_connector.connected) {
      Logger logger = Logger();
      try {
        _session = await _connector.createSession(
          onDisplayUri: (uri) async {
            _uri = uri;
            isAppInstalled = await canLaunchUrl(Uri.parse(uri));
            if (isAppInstalled) {
              await launchUrlString(uri, mode: LaunchMode.externalApplication);
            } else {
              logger.e(
                  "[MetamaskUtil] isConnected fail 메타마스크 설치 필요 isAppInstalled: $isAppInstalled");
            }
          },
        );

        // 지갑주소 및 체인아이디 설정
        _senderAddress = _session.accounts.first;

        return true;
      } catch (e) {
        // 연결 거절 상태 처리 예정
        logger.e("[MetamaskUtil] 지갑 연결 거절 및 오류 상태 $e");
      }
    }
    return false;
  }

  static Future<String> getMemberAddress() async {
    if (await isConnected()) {
      return _senderAddress;
    }
    return "";
  }

  // 후원 발생 및 후원 메서드
  static Future<int> handleGenerateSupport(
      int fundraiserId, double amount) async {
    DeployedContract? contract;
    Logger logger = Logger();
    final EthereumAddress contractAddr =
        EthereumAddress.fromHex("0xDFEe7A8b3E695364cF2dF476c00b58cC16eF9CeF");

    // json파일 -> abi
    await rootBundle.loadString('assets/contract.json').then((value) => {
          contract = DeployedContract(
              ContractAbi.fromJson(value, "poom"), contractAddr)
        });

    // contractFunction 설정
    ContractFunction? donate = contract?.function("donate");

    // 후원 발생 시간 설정
    DateTime dateTime = DateTime.now();
    int millisecondsSinceEpoch = dateTime.millisecondsSinceEpoch;
    var donationTime = millisecondsSinceEpoch;

    // provider 연결
    EthereumWalletConnectProvider provider =
        EthereumWalletConnectProvider(_connector);

    // memeberId 조회
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String memberId = preferences.getString("memberId")!;

    // 메타마스크 연결 여부 확인
    if (await isConnected()) {
      try {
        String contractAd = "0xDFEe7A8b3E695364cF2dF476c00b58cC16eF9CeF";
        final functionParameters = [
          BigInt.from(fundraiserId),
          memberId,
          BigInt.from(donationTime),
        ];

        final data = donate?.encodeCall(functionParameters);

        final uri = Uri.parse(_uri);
        if (!await launchUrl(uri)) {
          throw Exception('Could not launch $uri');
        }

        // 지갑에 후원할 만큼의 금액이 들어있는지 확인하고
        // 없을 때 처리
        var client = Web3Client(apiUrl, Client());
        var balance = await client.getBalance(
            EthereumAddress.fromHex(_senderAddress)); // WalletConnect로 받아온 잔고 값
        double walletConnectBalance = balance.getValueInUnit(EtherUnit.ether);

        if (walletConnectBalance < amount) {
          logger.e("[MetamaskUtils] handleGenerateSupport 잔고 부족 $amount");
          return -1;
        }

        var convertedAmount = amount * 1e18;
        String transactionHash = await provider.sendTransaction(
          from: _senderAddress,
          to: contractAd,
          data: data,
          value: BigInt.from(convertedAmount),
        );

        logger.i(
            "[MetamaskUtil] sendTransaction success transactionHash: $transactionHash");

        return 1;
      } catch (e) {
        logger.e("[MetamaskUtils]  sendTransaction fail $e");
        return 0;
      }
    }
    return 0;
  }

  // NFT 발급 메서드
  static void handleIssueNft(
      BuildContext context, Map<String, dynamic> data) async {
    Logger logger = Logger();

    if (await isConnected()) {
      try {
        EthereumWalletConnectProvider provider =
            EthereumWalletConnectProvider(_connector);

        final uri = Uri.parse(_uri);
        if (!await launchUrl(uri)) {
          throw Exception('Could not launch $uri');
        }

        var signature = await provider.personalSign(
            message: "ISSUED_NFT", address: _senderAddress, password: "");

        logger.d("[MetamaskUtil] sign success $signature");

        data.addAll({
          "memberAddress": _senderAddress,
          "memberSignature": signature,
          "signMessage": "ISSUE NFT"
        });

        NftApiService().issueNFt(context, data);
      } catch (e) {
        // 연결 거절 상태 처리 예정
        logger.e("[MetamaskUtil] 지갑 서명 오류 상태 $e");
        return;
      }
    }
  }
}
