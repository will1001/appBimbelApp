import 'package:fisikamu/FunctionGroup.dart';
import 'package:fisikamu/Widgets/CustomText.dart';
import 'package:flutter/material.dart';

Widget menuAppBar(BuildContext context, bool _showMenu, List _notifcation,
    var _closeMenu, var _logOut) {
  return _showMenu
      ? Positioned(
          top: 60,
          right: 9,
          child: Card(
            elevation: 9,
            child: SizedBox(
              height: 130,
              width: 150,
              child: Container(
                padding: EdgeInsets.all(0),
                height: 200,
                // width: 150,
                color: Colors.white,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/notifList',
                              arguments: <dynamic, dynamic>{
                                'data': _notifcation
                              });
                          _closeMenu();
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Stack(
                                alignment: Alignment.topLeft,
                                children: [
                                  Icon(Icons.notifications),
                                  _notifcation
                                              .where((e) =>
                                                  e['status'] == "not read")
                                              .toList()
                                              .length ==
                                          0
                                      ? Container()
                                      : Container(
                                          // padding: EdgeInsets.all(1),
                                          width: 14,
                                          height: 14,
                                          decoration: new BoxDecoration(
                                            color: Color(0xffBF1E2D),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              _notifcation
                                                  .where((e) =>
                                                      e['status'] == "not read")
                                                  .toList()
                                                  .length
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/notifList',
                                    arguments: <dynamic, dynamic>{
                                      'data': _notifcation
                                    });
                                _closeMenu();
                              },
                              child: customText(context, 'Notifikasi',
                                  TextAlign.left, 17, FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 8),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/profil');
                          _closeMenu();
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.settings),
                            ),
                            customText(context, 'Profil', TextAlign.left, 17,
                                FontWeight.w400)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 8),
                      child: GestureDetector(
                        onTap: _logOut,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.exit_to_app),
                            ),
                            customText(context, 'Log Out', TextAlign.left, 17,
                                FontWeight.w400)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      : Container();
}
