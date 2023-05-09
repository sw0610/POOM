import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

class MetaMaskUtil {
// walletConnect 객체 생성
  late WalletConnect? _connector;
  late SessionStatus? _session;
  late final String _senderAddress;

  MetaMaskUtil._privateConstructor();
  static final MetaMaskUtil _instance = MetaMaskUtil._privateConstructor();

  factory MetaMaskUtil() {
    return _instance;
  }

  void connectMetaMask() async {
    _connector = WalletConnect(
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

    if (!_connector!.connected) {
      try {
        _session = await _connector!.createSession(
          onDisplayUri: (uri) async {
            await launchUrlString(uri, mode: LaunchMode.externalApplication);
          },
        );
        // 지갑주소 및 체인아이디 설정
        _senderAddress = _session!.accounts[0];
        print("connectMetaMask()... $_senderAddress");
      } catch (e) {
        print("User Not Connect Metamask");
        disposeConnector();
      }
    }
  }

  void disposeConnector() async {
    await _connector!.killSession();
    _session = null;
  }
}
