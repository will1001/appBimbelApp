import 'package:flutter/material.dart';

import 'MenuIcon.dart';

class BottomNav2 extends StatefulWidget {
  const BottomNav2({Key? key}) : super(key: key);

  @override
  _BottomNav2State createState() => _BottomNav2State();
}

class _BottomNav2State extends State<BottomNav2> {
  int _menuSelected = 0;
  // _BottomNav2igationIndexChanger(int index) {
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
                      'Konsep',
                      16,
                      FontWeight.w400,
                      'assets/images/video red.svg',
                      'assets/images/video red.svg',
                      26,
                      23.66,
                      _menuSelected,
                      0, () {
                    // Navigator.pushNamed(context, '/home',
                    //     arguments: {"selectedIndex": 0});
                  }, context),
                  menuIcon(
                      'QnA',
                      16,
                      FontWeight.w400,
                      'assets/images/teks gray.svg',
                      'assets/images/teks gray.svg',
                      26,
                      23.66,
                      _menuSelected,
                      1, () {
                    // Navigator.pushNamed(context, '/home',
                    //     arguments: {"selectedIndex": 1});
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
