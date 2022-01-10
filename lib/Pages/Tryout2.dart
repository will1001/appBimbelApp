import 'dart:async';

import 'package:fisikamu/APIAction.dart';
import 'package:fisikamu/Provider/UserProvider.dart';
import 'package:fisikamu/Widgets/AppBarWithLogo.dart';
import 'package:fisikamu/Widgets/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class Tryout2 extends StatefulWidget {
  const Tryout2({Key? key}) : super(key: key);

  @override
  _Tryout2State createState() => _Tryout2State();
}

class _Tryout2State extends State<Tryout2> {
  bool _showMenu = false;
  List _listLevel = [];
  List _listUtbk = [];
  // List _listLevel = ['warrior', 'elite', 'Master', 'Grand Master'];
  // List _listUtbk = ['SBMPTN', 'UM UGM', 'SIMAK UI', 'LATIHAN 2021'];
  List _listPaketSoal = [];
  Timer? timer;
  int _notifData = 0;
  var userProvider;

  String _menuSelected = "";
  int? _subMenuIndex;

  loadPaket(String _tipePaket, String _idParam) {
    String _param = "";
    _tipePaket == 'UTBK' ? _param = 'id_utbk' : _param = 'id_level';

    getAPIbyParam('/paket_soal', '?$_param=$_idParam').then((res) {
      if (mounted) {
        setState(() {
          _listPaketSoal = res;
        });
      }
    });
  }

  changeMainMenu(String _menu) {
    if (mounted) {
      setState(() {
        _menuSelected = _menu;
        _subMenuIndex = null;
        _listPaketSoal.clear();
      });
    }
  }

  loadLevelAndUTBK() {
    getAPI('/tingkat_kesulitan').then((res) {
      if (mounted) {
        setState(() {
          _listLevel.addAll(res);
        });
      }
    });
    getAPI('/utbk').then((res) {
      _listUtbk.addAll(res);
    });
  }

  showNotif(var _data) async {
    // print(_data);
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(int.parse(_data['id']),
        _data['title'], _data['description'], platformChannelSpecifics,
        payload: 'data');
  }

  cekNotifBaru() {
    getAPI('/notification?id=${userProvider.getid}&status=not read')
        .then((res) {
      if (_notifData == res.length) {
        // print("tidak ada notif baru");
      } else {
        // print("Ada notif baru");
        showNotif(res[_notifData]);
        if (mounted) {
          setState(() {
            _notifData = res.length;
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadLevelAndUTBK();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => cekNotifBaru());
    getAPI('/notification?id=${userProvider.getid}&status=not read')
        .then((res) {
      if (mounted) {
        setState(() {
          _notifData = res.length;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                appBarWithLogo(
                    context, userProvider.userData['username'].toString(), () {
                  if (mounted) {
                    setState(() {
                      _showMenu = !_showMenu;
                    });
                  }
                }, () {
                  Navigator.pushNamed(context, '/profil');
                }, userProvider.userData['photo'].toString(),
                    _notifData.toString(), false),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width -
                              MediaQuery.of(context).size.width * 0.6,
                          height: 96,
                          color: Color(0xFFE9ECEB),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  changeMainMenu("BAB");
                                },
                                child: Container(
                                  width: 96,
                                  height: 29,
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      customText(
                                          context,
                                          'BAB',
                                          TextAlign.start,
                                          14,
                                          _menuSelected == 'BAB'
                                              ? FontWeight.bold
                                              : FontWeight.w400),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  changeMainMenu("UTBK");
                                },
                                child: Container(
                                  width: 96,
                                  height: 29,
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      customText(
                                          context,
                                          'UTBK',
                                          TextAlign.start,
                                          14,
                                          _menuSelected == 'UTBK'
                                              ? FontWeight.bold
                                              : FontWeight.w400),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Container(
                            // height: MediaQuery.of(context).size.height,
                            // width: 246,
                            // color: Color(0xFFE9ECEB),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: (_menuSelected == ''
                                        ? []
                                        : _menuSelected == 'BAB'
                                            ? _listLevel
                                            : _listUtbk)
                                    .asMap()
                                    .map((i, e) => MapEntry(
                                        i,
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 13.0),
                                          child: Container(
                                            color: _subMenuIndex == i
                                                ? Colors.white
                                                : Colors.transparent,
                                            width: 100,
                                            // height: 35,
                                            padding: const EdgeInsets.only(
                                                left: 9, top: 9, bottom: 9),
                                            child: GestureDetector(
                                              onTap: () {
                                                if (_menuSelected == 'BAB') {
                                                  if (mounted) {
                                                    setState(() {
                                                      _subMenuIndex = i;
                                                    });
                                                  }
                                                  loadPaket('BAB', e['id']);
                                                } else {
                                                  if (mounted) {
                                                    setState(() {
                                                      _subMenuIndex = i;
                                                    });
                                                  }
                                                  loadPaket('UTBK', e['id']);
                                                }
                                              },
                                              child: customText(
                                                  context,
                                                  e['deskripsi'],
                                                  TextAlign.start,
                                                  16,
                                                  FontWeight.w700),
                                            ),
                                          ),
                                        )))
                                    .values
                                    .toList(),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width -
                          MediaQuery.of(context).size.width * 0.45,
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _listPaketSoal.map((e) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/showSoal',
                                        arguments: e);
                                  },
                                  child: customText(context, e['deskripsi'],
                                      TextAlign.start, 14, FontWeight.w400),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
