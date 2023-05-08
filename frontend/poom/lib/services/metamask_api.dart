import 'package:http/http.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/web3dart.dart';

class MetamaskApi {
  late final _session, _uri;

  var sepoliaUrl =
      "https://sepolia.infura.io/v3/5aff15fef45e416db6343a1850399c1c"; // sepolia url 설정

  // walletConnect 연결
  final connector = WalletConnect(
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

  // metamask 연결
  handleConnectMetamask() async {
    try {
      var session = await connector.createSession(onDisplayUri: (uri) async {
        _uri = uri;
        await launchUrlString(uri, mode: LaunchMode.externalApplication);
      });

      _session = session;
    } catch (error) {
      print("connectMetamask Error: $error");
    }
  }

  // 후원하기
  handleSupport() async {
    // 연결이 끊겼다면, 연결 시도
    if (!connector.connected) {
      await handleConnectMetamask();
    }

    // test
    var httpClient = Client();
    var ethClient = Web3Client(sepoliaUrl, httpClient);
    var credentials = EthPrivateKey.fromHex(_session.accounts[0]);
    var sender = EthereumAddress.fromHex(_session.accounts[0]);

    // 체인 아이디
    var chainId = await ethClient.getChainId();
    final chainIdAsInt = chainId.toInt();

    print("chainId $chainId");
    print("chainIdInt $chainIdAsInt");

    // 가스비용 - 현재 네트워크의 가스비용
    var gasPrice = await ethClient.getGasPrice();
    var maxGas = await ethClient.estimateGas();

    // 트랜잭션
    var transaction = Transaction(
      from: sender,
      to: EthereumAddress.fromHex('0xb3d8D0965c8Df86DC7f4772115aC03f2D9487CB4'),
      gasPrice: gasPrice,
      maxGas: 100000,
      value: EtherAmount.inWei(BigInt.one),
    );

    print("내 잔고 : ${await ethClient.getBalance(sender)}");
    print("현재 가스 비용 : ${transaction.gasPrice}");
    print("최대 가스 : ${transaction.maxGas}");
    print("후원 비용 : ${transaction.value}");

    await ethClient.sendTransaction(
      credentials,
      transaction,
      chainId: chainIdAsInt,
    );
    await ethClient.dispose();
  }
}
