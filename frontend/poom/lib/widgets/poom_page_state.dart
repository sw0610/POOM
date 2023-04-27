import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poom/screens/collection_screen.dart';
import 'package:poom/screens/home_screen.dart';
import 'package:poom/screens/profile_screen.dart';

class PoomPageState extends StatefulWidget {
  const PoomPageState({super.key});

  @override
  State<PoomPageState> createState() => _PoomPageState();
}

class _PoomPageState extends State<PoomPageState> {
  int _selectedIndex = 0; // current bottom tab index

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CollectionScreen(),
    ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: SizedBox(
        height: 72,
        child: BottomNavigationBar(
          elevation: 4,
          unselectedFontSize: 14,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 4),
                child: SvgPicture.asset(
                  "assets/icons/ic_home.svg",
                ),
              ),
              label: 'Home',
              activeIcon: Container(
                padding: const EdgeInsets.only(bottom: 4),
                child: SvgPicture.asset(
                  "assets/icons/ic_home.svg",
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).primaryColor, BlendMode.srcIn),
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 4),
                child: SvgPicture.asset(
                  "assets/icons/ic_collection.svg",
                ),
              ),
              label: 'Collection',
              activeIcon: Container(
                padding: const EdgeInsets.only(bottom: 4),
                child: SvgPicture.asset(
                  "assets/icons/ic_collection.svg",
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).primaryColor, BlendMode.srcIn),
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 4),
                child: SvgPicture.asset(
                  "assets/icons/ic_profile.svg",
                ),
              ),
              label: 'Profile',
              activeIcon: Container(
                padding: const EdgeInsets.only(bottom: 4),
                child: SvgPicture.asset(
                  "assets/icons/ic_profile.svg",
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).primaryColor, BlendMode.srcIn),
                ),
              ),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
