import 'package:flutter/material.dart';

import 'MenuIcon.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _menuSelected = 0;
  // _bottomNavigationIndexChanger(int index) {
  //   if (mounted){setState(() {
  //     _menuSelected = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70,
      child: Card(
        elevation: 9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  menuIcon(
                      'Home',
                      16,
                      FontWeight.w400,
                      'assets/images/home_red.svg',
                      'assets/images/home_gray.svg',
                      26,
                      23.66,
                      _menuSelected,
                      0, () {
                    Navigator.pushNamed(context, '/home',
                        arguments: {"selectedIndex": 0});
                  }, context),
                  menuIcon(
                      'Tryout',
                      16,
                      FontWeight.w400,
                      'assets/images/tryout_red.svg',
                      'assets/images/tryout_gray.svg',
                      26,
                      23.66,
                      _menuSelected,
                      1, () {
                    Navigator.pushNamed(context, '/home',
                        arguments: {"selectedIndex": 1});
                  }, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
