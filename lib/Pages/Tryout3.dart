import 'dart:async';

import 'package:fisikamu/APIAction.dart';
import 'package:fisikamu/Provider/UserProvider.dart';
import 'package:fisikamu/Widgets/AppBarWithLogo.dart';
import 'package:fisikamu/Widgets/Backgorund.dart';
import 'package:fisikamu/Widgets/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class Tryout extends StatefulWidget {
  const Tryout({Key? key}) : super(key: key);

  @override
  _TryoutState createState() => _TryoutState();
}

class _TryoutState extends State<Tryout> {
  bool _showMenu = false;
  // List _listLevel = [];
  List _listUtbk = [];
  List _listSubBab = [];
  // List _listLevel = ['warrior', 'elite', 'Master', 'Grand Master'];
  // List _listUtbk = ['SBMPTN', 'UM UGM', 'SIMAK UI', 'LATIHAN 2021'];
  List _listPaketSoal = [];
  Timer? timer;
  int _notifData = 0;
  var userProvider;
  String? selected;

  String _menuSelected = "UTBK";
  // int? _subMenuIndex;

  loadPaket(String _tipePaket) {
    // loadPaket() {
    // String _param = "";
    // _tipePaket == 'UTBK' ? _param = '1' : _param = '0';

    getAPIbyParam('/paket_soal', '?tipe=$_tipePaket').then((res) {
      if (mounted) {
        setState(() {
          _listPaketSoal = res;
        });
      }
    });
    // getAPI('/paket_soal').then((res) {
    //   if (mounted){setState(() {
    //     _listPaketSoal.addAll(res);
    //   });
    // });
  }

  changeMainMenu(String _menu) {
    if (mounted) {
      setState(() {
        _menuSelected = _menu;
        selected = null;
        _listPaketSoal.clear();
      });
    }
    loadPaket(_menu);
  }

  loadLevelAndUTBK() {
    // getAPI('/tingkat_kesulitan').then((res) {
    //   if (mounted){setState(() {
    //     _listLevel.addAll(res);
    //   });
    // });
    getAPI('/utbk').then((res) {
      _listUtbk.addAll(res);
    });
    getAPI('/SubBab_soal').then((res) {
      _listSubBab.addAll(res);
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
    loadPaket('UTBK');
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
        children: [
          background(context, Color(0xFFE5E5E5)),
          Stack(
            alignment: Alignment.topRight,
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  padding: EdgeInsets.only(bottom: 60),
                  child: ListView(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        color: Color(0xffEE5454),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Image.asset(
                                "assets/images/logoWhite.png",
                                width: 100,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 74,
                        color: Color(0xFFE5E5E5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
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
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: _menuSelected == 'BAB'
                              ? _listSubBab.length
                              : _menuSelected == 'UTBK'
                                  ? _listUtbk.length
                                  : 0,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: ExpansionTile(
                                key: Key(_menuSelected == 'BAB'
                                    ? 'bab_' + _listSubBab[index]['id']
                                    : 'utbk_' + _listUtbk[index]['id']),
                                initiallyExpanded: (_menuSelected == 'BAB'
                                        ? 'bab_' + _listSubBab[index]['id']
                                        : 'utbk_' + _listUtbk[index]['id']) ==
                                    selected,
                                onExpansionChanged: (newState) {
                                  if (mounted) {
                                    setState(() {
                                      selected = (_menuSelected == 'BAB'
                                          ? 'bab_' + _listSubBab[index]['id']
                                          : 'utbk_' + _listUtbk[index]['id']);
                                    });
                                  }
                                },
                                title: Text(
                                  _menuSelected == 'BAB'
                                      ? _listSubBab[index]['sub_bab']
                                      : _menuSelected == 'UTBK'
                                          ? _listUtbk[index]['deskripsi']
                                          : "",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                children: (_menuSelected == 'BAB'
                                        ? _listPaketSoal
                                            .where((el) =>
                                                el['id_sub_bab'] ==
                                                _listSubBab[index]['id'])
                                            .toList()
                                        : _listPaketSoal
                                            .where((el) =>
                                                el['id_utbk'] ==
                                                _listUtbk[index]['id'])
                                            .toList())
                                    .map((e) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/showSoal',
                                          arguments: {
                                            'data': e,
                                            'mode': 'Quiz',
                                            'jawaban': []
                                          });
                                    },
                                    child: ListTile(
                                      title: Row(
                                        children: [
                                          Text(
                                            _menuSelected == "BAB"
                                                ? e['nama_paket']
                                                : e['deskripsi'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                          _menuSelected == "BAB"
                                              ? Text(
                                                  " (${e['nama_level']})",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                )
                                              : Container()
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                                // children: <Widget>[
                                //   ListTile(
                                //     title: Text(
                                //       'asdasd',
                                //       style: TextStyle(fontWeight: FontWeight.w700),
                                //     ),
                                //   )
                                // ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
