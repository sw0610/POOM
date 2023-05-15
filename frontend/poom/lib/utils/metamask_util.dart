import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:poom/services/nft_api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

class MetamaskUtil {
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

  static WalletConnect getConnector() {
    return _connector;
  }

  // 메타마스크 연결 메서드
  static void handleConnectMetamask() async {
    Logger logger = Logger();
    // connected 여부 확인
    if (!_connector.connected) {
      try {
        _session = await _connector.createSession(
          onDisplayUri: (uri) async {
            bool isLaunched = await launchUrlString(uri,
                mode: LaunchMode.externalApplication);

            // metamask 설치여부에 따른 가이드 제공
            if (!isLaunched) {
              logger.d("[MetamaskUtil] Metamask 설치 필요");
              return;
            }
          },
        );
        // 지갑주소 및 체인아이디 설정
        _senderAddress = _session.accounts.first;
        logger.d("[MetamaskUtil] 지갑 연결 성공 $_session");
      } catch (e) {
        // 연결 거절 상태 처리 예정
        logger.e("[MetamaskUtil] 지갑 연결 거절 및 오류 상태 $e");
        return;
      }
    }

    // 연결 후 지갑 주소를 받아왔다면 후원 발생
    // if (_senderAddress.isNotEmpty) {
    //   handleGenerateSupport();
    // }
  }

  // 후원 발생 및 후원 메서드
  static void handleGenerateSupport() async {
    Logger logger = Logger();
    EthereumWalletConnectProvider provider =
        EthereumWalletConnectProvider(_connector);

    try {
      var result = await provider.sendTransaction(
        from: _senderAddress,
        to: "0xb3d8D0965c8Df86DC7f4772115aC03f2D9487CB4",
        value: BigInt.one,
      );
      logger.d("[MetamaskUtil] 후원 요청 성공 $result");
    } catch (e) {
      // 후원 거절 상태 처리 예정
      logger.e("[MetamaskUtil] 후원 요청 실패 $e");
    }
  }

  static Future<bool> isConnected() async {
    if (!_connector.connected) {
      Logger logger = Logger();
      try {
        _session = await _connector.createSession(
          onDisplayUri: (uri) async {
            _uri = uri;
            bool isLaunched = await launchUrlString(uri,
                mode: LaunchMode.externalApplication);

            // metamask 설치여부에 따른 가이드 제공
            if (!isLaunched) {
              logger.d("[MetamaskUtil] Metamask 설치 필요");
              return;
            }
          },
        );

        // 지갑주소 및 체인아이디 설정
        _senderAddress = _session.accounts.first;
        return true;
      } catch (e) {
        // 연결 거절 상태 처리 예정
        logger.e("[MetamaskUtil] 지갑 연결 거절 및 오류 상태 $e");
        return false;
      }
    }
    return true;
  }

  static void handleIssueNft(
      BuildContext context, Map<String, dynamic> data) async {
    Logger logger = Logger();

    if (await isConnected()) {
      logger.d("연결 여부 확인 >> 연결됨, $_uri");
      logger.d("연결 여부 확인 >> 연결됨, session > $_session");
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
