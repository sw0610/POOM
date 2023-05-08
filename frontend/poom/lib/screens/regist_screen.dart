import 'package:flutter/material.dart';
import 'package:poom/widgets/regist/regist_nft_preview.dart';
import 'package:poom/widgets/regist/regist_representive_widget.dart';
import 'package:poom/widgets/regist/regist_specific_info_widget.dart';

class RegistScreen extends StatefulWidget {
  const RegistScreen({Key? key}) : super(key: key);

  @override
  _RegistScreenState createState() => _RegistScreenState();
}

class _RegistScreenState extends State<RegistScreen> {
  int _selectedIndex = 0; // 선택된 인덱스

  void nextPage() {
    if (_selectedIndex < 1) {
      setState(() {
        _selectedIndex = _selectedIndex + 1;
      });
    }
  }

  void prevPage() {
    if (_selectedIndex > 0) {
      _selectedIndex = _selectedIndex - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('보호견 등록'),
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: const Color(0xFF333333),
        centerTitle: true,
        elevation: 1,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          RegistRepresentive(nextPage: nextPage),
          const RegistNftPreview(),
          const RegistSpecificInfo(),
        ],
      ),
    );
  }
}
