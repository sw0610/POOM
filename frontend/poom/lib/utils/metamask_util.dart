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
  static late final SessionStatus? _session;
  static late final String _senderAddress;

  static WalletConnect getConnector() {
    return _connector;
  }

  // 메타마스크 연결 메서드
  static void handleConnectMetamask() async {
    // connected 여부 확인
    if (!_connector.connected) {
      try {
        _session = await _connector.createSession(
          onDisplayUri: (uri) async {
            bool isLaunched = await launchUrlString(uri,
                mode: LaunchMode.externalApplication);

            // metamask 설치여부에 따른 가이드 제공
            if (!isLaunched) {
              print("설치 필요 가이드 제공");
              return;
            }
          },
        );
        // 지갑주소 및 체인아이디 설정
        _senderAddress = _session!.accounts.first;
      } catch (e) {
        print("[MetamaskUtil] 메타마스크 연결 거절 : $e");
        return;
      }
    }

    // 연결 후 지갑 주소를 받아왔다면 후원 발생
    if (_senderAddress.isNotEmpty) {
      handleGenerateSupport();
    }
  }

  // 후원 발생 및 후원 메서드
  static void handleGenerateSupport() async {
    EthereumWalletConnectProvider provider =
        EthereumWalletConnectProvider(_connector);

    try {
      var result = await provider.sendTransaction(
        from: _senderAddress,
        to: "0xb3d8D0965c8Df86DC7f4772115aC03f2D9487CB4",
        value: BigInt.one,
      );
      print("[MetamaskUtil] 후원 성공");
    } catch (e) {
      print("[MetamaskUtil] 후원 실패 $e");
      handleDispose();
    }
  }

  static void handleDispose() async {
    print("[MetamaskUtil] WalletConnect 세션 종료");
    await _connector.killSession(); // WalletConnect 인스턴스 종료
    _session = null;
  }
}
