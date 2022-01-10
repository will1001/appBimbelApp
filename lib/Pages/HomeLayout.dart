import 'package:fisikamu/Pages/Home.dart';
import 'package:fisikamu/Pages/Tryout.dart';
import 'package:fisikamu/Widgets/ButtonStyle1.dart';
import 'package:fisikamu/Widgets/MenuIcon.dart';
import 'package:fisikamu/Widgets/PanelPopUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _selectedIndex = 0;
  int _menuSelected = 0;
  DateTime? currentBackPressTime;
  bool _showPopUp = false;
  String? _popUpMessage;
  List<Widget> _widgetPopUpButton = [];

  _bottomNavigationIndexChanger(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
        _menuSelected = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      var arguments = (ModalRoute.of(context)!.settings.arguments as Map);
      // ignore: unnecessary_null_comparison

      if (arguments['selectedIndex'] != null) {
        if (mounted) {
          setState(() {
            _selectedIndex = arguments['selectedIndex'];
            _menuSelected = arguments['selectedIndex'];
          });
        }
      }
    });
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      if (_showPopUp) {
        if (mounted) {
          setState(() {
            _showPopUp = false;
          });
        }
      } else {
        currentBackPressTime = now;
      }
      // Fluttertoast.showToast(msg: exit_warning);
      return Future.value(false);
    }
    // print("Asfasf");
    if (mounted) {
      setState(() {
        _showPopUp = true;
        _popUpMessage = "Keluar dari App?";
        _widgetPopUpButton = [
          buttonStyle1(context, 70, 'Ya', Color(0xFFF6F5FF), Colors.black, () {
            SystemNavigator.pop();
          }),
          buttonStyle1(context, 70, 'Tidak', Color(0xFFF6F5FF), Colors.black,
              () {
            if (mounted) {
              setState(() {
                _showPopUp = false;
              });
            }
          }),
        ];
      });
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Home(),
      Tryout(),
    ];
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Center(child: _widgetOptions.elementAt(_selectedIndex)),
                Container(
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
                                _bottomNavigationIndexChanger(0);
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
                                _bottomNavigationIndexChanger(1);
                              }, context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            _showPopUp
                ? panelPopUp(
                    context, _popUpMessage.toString(), _widgetPopUpButton)
                : Container()
          ],
        ),
      ),
    );
  }
}
