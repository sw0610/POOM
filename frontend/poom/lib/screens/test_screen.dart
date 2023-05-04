import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late final _session, _uri;

  // walletConnect 연결
  final connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
          name: 'POOM',
          description: 'An app for converting pictures to NFT',
          url: 'https://walletconnect.org',
          icons: [
            'https://velog.velcdn.com/images/taebong1012/profile/64d88125-3ac8-461d-8537-40dad38b0097/image.png'
          ]));

  // metamask 연결
  connectMetamask(BuildContext context) async {
    if (!connector.connected) {
      try {
        var session = await connector.createSession(onDisplayUri: (uri) async {
          _uri = uri;
          await launchUrlString(uri, mode: LaunchMode.externalApplication);
        });

        // session.accounts[0]
        // session.chainId

        // session 반영
        setState(() {
          _session = session;
        });
      } catch (error) {
        print("connectMetamask Error: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () => connectMetamask(context),
          child: const Text("메타마스크 연결"),
        ),
      ),
    );
  }
}
