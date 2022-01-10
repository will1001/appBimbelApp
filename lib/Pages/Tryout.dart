import 'dart:async';

import 'package:fisikamu/APIAction.dart';
import 'package:fisikamu/Provider/UserProvider.dart';
import 'package:fisikamu/Widgets/AppBarWithLogo.dart';
import 'package:fisikamu/Widgets/Backgorund.dart';
import 'package:fisikamu/Widgets/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class Tryout extends StatefulWidget {
  const Tryout({Key? key}) : super(key: key);

  @override
  _TryoutState createState() => _TryoutState();
}

class _TryoutState extends State<Tryout> with TickerProviderStateMixin {
  bool _showMenu = false;
  // List _listLevel = [];
  late TabController _tabController;

  List _listUtbk = [];
  List _listSubBab = [];
  // List _listLevel = ['warrior', 'elite', 'Master', 'Grand Master'];
  // List _listUtbk = ['SBMPTN', 'UM UGM', 'SIMAK UI', 'LATIHAN 2021'];
  List _listPaketSoalUTBK = [];
  List _listPaketSoalBAB = [];
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
          _tipePaket == 'BAB'
              ? _listPaketSoalBAB = res
              : _listPaketSoalUTBK = res;
        });
      }
    });
    // getAPI('/paket_soal').then((res) {
    //   if (mounted){setState(() {
    //     _listPaketSoal.addAll(res);
    //   });
    // });
  }

  // changeMainMenu(String _menu) {
  //   if (mounted) {
  //     setState(() {
  //       _menuSelected = _menu;
  //       selected = null;
  //       _listPaketSoal.clear();
  //     });
  //   }
  //   loadPaket(_menu);
  // }

  loadLevelAndUTBK() {
    // getAPI('/tingkat_kesulitan').then((res) {
    //   if (mounted){setState(() {
    //     _listLevel.addAll(res);
    //   });
    // });
    getAPI('/utbk').then((res) {
      _listUtbk = res;
    });
    getAPI('/SubBab_soal').then((res) {
      _listSubBab = res;
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

  Widget tab_view(int _index) {
    // print('asdsadsadasdasdasdadasdasdasdxxxxx');
    // print(_listSubBab.length);
    // print('==============asdsadsadasdasdasdadasdasdasdxxxxx');
    // print(_listUtbk.length);
    // print(_listUtbk);
    // print('2==============asdsadsadasdasdasdadasdasdasdxxxxx');
    // print(_listPaketSoalBAB);
    if (_listSubBab.length != 0 || _listUtbk.length != 0) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: _index == 1
              ? _listSubBab.length
              : _index == 0
                  ? _listUtbk.length
                  : 0,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 1,
                  color: Color(0xffBFBFBF),
                )),
                child: ExpansionTile(
                  // trailing: Opacity(
                  //     opacity: 0, child: Icon(Icons.ac_unit)),
                  key: Key(_index == 1
                      ? 'bab_' + _listSubBab[index]['id']
                      : 'utbk_' + _listUtbk[index]['id']),
                  initiallyExpanded: (_index == 1
                          ? 'bab_' + _listSubBab[index]['id']
                          : 'utbk_' + _listUtbk[index]['id']) ==
                      selected,
                  onExpansionChanged: (expanded) {
                    if (mounted) {
                      setState(() {
                        if (expanded) {
                          selected = (_index == 1
                              ? 'bab_' + _listSubBab[index]['id']
                              : 'utbk_' + _listUtbk[index]['id']);
                        } else {}
                      });
                    }
                  },
                  title: Text(
                    _index == 1
                        ? _listSubBab[index]['sub_bab']
                        : _index == 0
                            ? _listUtbk[index]['deskripsi']
                            : "",
                    style: TextStyle(
                        fontSize: 16.0,
                        // color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  children:
                      (_index == 0 ? _listPaketSoalUTBK : _listPaketSoalBAB)
                          .map((e) {
                    // print(e);
                    return Column(
                      children: [
                        GestureDetector(
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
                                  _index == 1
                                      ? e['nama_paket']
                                      : e['deskripsi'],
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                _index == 1
                                    ? Text(
                                        " (${e['nama_level']})",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      );
    }

    return Container();
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
    _tabController = TabController(length: 2, vsync: this);
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
    loadPaket('BAB');
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
          background(context, Color(0xFFffffff)),
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
                              child: SvgPicture.asset(
                                "assets/images/Logo2.svg",
                                color: Colors.white,
                                width: 100,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(0.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       GestureDetector(
                      //         onTap: () {
                      //           changeMainMenu("UTBK");
                      //         },
                      //         child: Container(
                      //           width: MediaQuery.of(context).size.width * 0.5,
                      //           padding: const EdgeInsets.only(top: 8),
                      //           color: Colors.transparent,
                      //           child: Column(
                      //             children: [
                      //               Text(
                      //                 "Tryout UTBK",
                      //                 style: TextStyle(
                      //                     color: _menuSelected == "UTBK"
                      //                         ? Colors.black
                      //                         : Colors.black38,
                      //                     fontSize: 16,
                      //                     fontWeight: FontWeight.w400,
                      //                     fontFamily: "Nunito"),
                      //               ),
                      //               Opacity(
                      //                 opacity: _menuSelected == "UTBK" ? 1 : 0,
                      //                 child: Padding(
                      //                   padding:
                      //                       const EdgeInsets.only(top: 8.0),
                      //                   child: Container(
                      //                     width: 140,
                      //                     height: 3,
                      //                     color: Color(0xffEE5454),
                      //                   ),
                      //                 ),
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //       GestureDetector(
                      //         onTap: () {
                      //           changeMainMenu("BAB");
                      //         },
                      //         child: Container(
                      //           width: MediaQuery.of(context).size.width * 0.5,
                      //           padding: const EdgeInsets.only(top: 8),
                      //           color: Colors.transparent,
                      //           child: Column(
                      //             children: [
                      //               Text(
                      //                 "Tryout BAB",
                      //                 style: TextStyle(
                      //                     color: _menuSelected == "BAB"
                      //                         ? Colors.black
                      //                         : Colors.black38,
                      //                     fontSize: 16,
                      //                     fontWeight: FontWeight.w400,
                      //                     fontFamily: "Nunito"),
                      //               ),
                      //               Opacity(
                      //                 opacity: _menuSelected == "BAB" ? 1 : 0,
                      //                 child: Padding(
                      //                   padding:
                      //                       const EdgeInsets.only(top: 8.0),
                      //                   child: Container(
                      //                     width: 140,
                      //                     height: 3,
                      //                     color: Color(0xffEE5454),
                      //                   ),
                      //                 ),
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      TabBar(
                          controller: _tabController,
                          labelColor: Colors.black,
                          indicatorColor: Color(0xffEE5454),
                          labelStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Nunito"),
                          tabs: [
                            Tab(
                              text: 'Tryout UTBK',
                            ),
                            Tab(
                              text: 'Tryout BAB',
                            ),
                          ]),

                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: ListView.builder(
                      //     scrollDirection: Axis.vertical,
                      //     shrinkWrap: true,
                      //     physics: BouncingScrollPhysics(),
                      //     itemCount: _menuSelected == 'BAB'
                      //         ? _listSubBab.length
                      //         : _menuSelected == 'UTBK'
                      //             ? _listUtbk.length
                      //             : 0,
                      //     itemBuilder: (BuildContext context, int index) {
                      //       return Padding(
                      //         padding:
                      //             const EdgeInsets.symmetric(vertical: 8.0),
                      //         child: Container(
                      //           decoration: BoxDecoration(
                      //               border: Border.all(
                      //             width: 1,
                      //             color: Color(0xffBFBFBF),
                      //           )),
                      //           child: ExpansionTile(
                      //             // trailing: Opacity(
                      //             //     opacity: 0, child: Icon(Icons.ac_unit)),
                      //             key: Key(_menuSelected == 'BAB'
                      //                 ? 'bab_' + _listSubBab[index]['id']
                      //                 : 'utbk_' + _listUtbk[index]['id']),
                      //             initiallyExpanded: (_menuSelected == 'BAB'
                      //                     ? 'bab_' + _listSubBab[index]['id']
                      //                     : 'utbk_' + _listUtbk[index]['id']) ==
                      //                 selected,
                      //             onExpansionChanged: (expanded) {
                      //               if (mounted) {
                      //                 setState(() {
                      //                   if (expanded) {
                      //                     selected = (_menuSelected == 'BAB'
                      //                         ? 'bab_' +
                      //                             _listSubBab[index]['id']
                      //                         : 'utbk_' +
                      //                             _listUtbk[index]['id']);
                      //                   } else {}
                      //                 });
                      //               }
                      //             },
                      //             title: Text(
                      //               _menuSelected == 'BAB'
                      //                   ? _listSubBab[index]['sub_bab']
                      //                   : _menuSelected == 'UTBK'
                      //                       ? _listUtbk[index]['deskripsi']
                      //                       : "",
                      //               style: TextStyle(
                      //                   fontSize: 16.0,
                      //                   // color: Colors.black,
                      //                   fontWeight: FontWeight.w500),
                      //             ),
                      //             children: (_menuSelected == 'BAB'
                      //                     ? _listPaketSoal
                      //                         .where((el) =>
                      //                             el['id_sub_bab'] ==
                      //                             _listSubBab[index]['id'])
                      //                         .toList()
                      //                     : _listPaketSoal
                      //                         .where((el) =>
                      //                             el['id_utbk'] ==
                      //                                 _listUtbk[index]['id'] &&
                      //                             el['status'] == "publish")
                      //                         .toList())
                      //                 .map((e) {
                      //               return Column(
                      //                 children: [
                      //                   GestureDetector(
                      //                     onTap: () {
                      //                       Navigator.pushNamed(
                      //                           context, '/showSoal',
                      //                           arguments: {
                      //                             'data': e,
                      //                             'mode': 'Quiz',
                      //                             'jawaban': []
                      //                           });
                      //                     },
                      //                     child: ListTile(
                      //                       title: Row(
                      //                         children: [
                      //                           Text(
                      //                             _menuSelected == "BAB"
                      //                                 ? e['nama_paket']
                      //                                 : e['deskripsi'],
                      //                             style: TextStyle(
                      //                                 fontWeight:
                      //                                     FontWeight.w700),
                      //                           ),
                      //                           _menuSelected == "BAB"
                      //                               ? Text(
                      //                                   " (${e['nama_level']})",
                      //                                   style: TextStyle(
                      //                                       fontWeight:
                      //                                           FontWeight
                      //                                               .w700),
                      //                                 )
                      //                               : Container()
                      //                         ],
                      //                       ),
                      //                     ),
                      //                   ),
                      //                   // GestureDetector(
                      //                   //   onTap: () {
                      //                   //     Navigator.pushNamed(
                      //                   //         context, '/showSoalMirror',
                      //                   //         arguments: {
                      //                   //           'data': e,
                      //                   //           'mode': 'Quiz',
                      //                   //           'jawaban': []
                      //                   //         });
                      //                   //   },
                      //                   //   child: ListTile(
                      //                   //     title: Row(
                      //                   //       children: [
                      //                   //         Text(
                      //                   //           _menuSelected == "BAB"
                      //                   //               ? e['nama_paket']
                      //                   //               : e['deskripsi'] +
                      //                   //                   "(tanpa latex)",
                      //                   //           style: TextStyle(
                      //                   //               fontWeight:
                      //                   //                   FontWeight.w700),
                      //                   //         ),
                      //                   //         _menuSelected == "BAB"
                      //                   //             ? Text(
                      //                   //                 " (${e['nama_level']})",
                      //                   //                 style: TextStyle(
                      //                   //                     fontWeight:
                      //                   //                         FontWeight
                      //                   //                             .w700),
                      //                   //               )
                      //                   //             : Container()
                      //                   //       ],
                      //                   //     ),
                      //                   //   ),
                      //                   // ),
                      //                 ],
                      //               );
                      //             }).toList(),
                      //             // children: <Widget>[
                      //             //   ListTile(
                      //             //     title: Text(
                      //             //       'asdasd',
                      //             //       style: TextStyle(fontWeight: FontWeight.w700),
                      //             //     ),
                      //             //   )
                      //             // ],
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: TabBarView(
                controller: _tabController,
                children: [0, 1].map((e) => tab_view(e)).toList()),
          ),
        ],
      ),
    );
  }
}
