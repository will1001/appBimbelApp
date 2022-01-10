import 'dart:async';
import 'dart:convert';

import 'package:fisikamu/APIAction.dart';
import 'package:fisikamu/Provider/GlobalProvider.dart';
import 'package:fisikamu/Provider/UserProvider.dart';
import 'package:fisikamu/Widgets/AppBarWithLogo.dart';
import 'package:fisikamu/Widgets/Backgorund.dart';
import 'package:fisikamu/Widgets/ButtonStyle1.dart';
import 'package:fisikamu/Widgets/MenuAppBar.dart';
import 'package:fisikamu/Widgets/MenuIconBab.dart';
import 'package:fisikamu/Widgets/PanelPopUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../FunctionGroup.dart';
import '../main.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Timer? timer;
  bool _showMenu = false;
  bool _showPopUp = false;
  List _listBab = [];
  List _listContent = [];
  List _notifcationNotRead = [];
  int _notifData = 0;
  String? _screen;

  sisaWaktu(DateTime from, DateTime to) {
    var diff = to.difference(from);
    var timeLeft = 24 * 3600 - diff.inSeconds;
    if (int.parse(timeLeft.toString()) < 0) timeLeft = 0;
    return (timeLeft.toString());
  }

  getBab() {
    getAPI('/bab_soal').then((res) {
      if (mounted) {
        setState(() {
          _listBab = res;
        });
      }
    });
  }

  getSlideContent() {
    getAPI('/slide_content').then((res) {
      if (mounted) {
        setState(() {
          _listContent = res;
        });
      }
    });
  }

  showNotif(var _data) async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
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
        payload: jsonEncode({
          "id": _data['id'],
          "title": _data['title'],
          "id_users": userProvider.getid,
          "description": _data['description'],
          "created_at": _data['created_at']
        }));
  }

  cekNotifBaru() {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    getAPI('/notification?id_users=${userProvider.getid}').then((res) {
      // print(_notifData);
      // print(res.length);
      List bodyRes = res;
      // print(bodyRes);
      if (mounted) {
        setState(() {
          _notifcationNotRead = bodyRes
              .where((e) =>
                  int.parse((sisaWaktu(
                      DateTime.parse(e['created_at'].toString()),
                      DateTime.now()))) !=
                  0)
              .toList();
        });
      }
      // print(_notifData == res.length);
      if (_notifData == res.length) {
        // print("tidak ada notif baru");
      } else {
        // print("Ada notif baru");
        int i = res.length - 1;
        // print(i);
        if (res[i]['send_status'] == "not send") {
          showNotif(res[i]);
          Map<String, String> data = {
            "id": res[i]['id'],
            "id_users": res[i]['id_users'],
            "title": res[i]['title'],
            "description": res[i]['description'],
            "status": res[i]['status'],
            "send_status": "sended",
          };
          putAPI('/notification', data);
        }

        if (mounted) {
          setState(() {
            _notifData = res.length;
          });
        }
      }
    });
  }

  void _configureSelectNotificationSubject() {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    getAPI('/notification?id=${userProvider.getid}&status=not read')
        .then((res) {
      if (res.length != 0) {
        // print("212");
        // print(res.length);
        selectNotificationSubject.stream.listen((String? payload) async {
          var data = jsonDecode(payload.toString());
          await Navigator.pushNamed(context, '/detailsNotif', arguments: data);
        });
      }
    });
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  @override
  void initState() {
    super.initState();
    // var userProvider = Provider.of<UserProvider>(context, listen: false);
    getBab();
    getSlideContent();
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => cekNotifBaru());
    // getAPI('/notification?id=${userProvider.getid}&status=not read')
    //     .then((res) {
    //   if (mounted){setState(() {
    //     _notifData = res.length;
    //   });
    // });
    _requestPermissions();
    _configureSelectNotificationSubject();
  }

  heightSlide(String? _layar) {
    switch (_layar) {
      case 'Screen 1':
        return 190.0;
      case 'Screen 2':
        return 190.0;
      default:
    }
  }

  ratioIcon(String? _layar) {
    switch (_layar) {
      case 'Screen 1':
        return 190.0;
      case 'Screen 2':
        return 190.0;
      default:
    }
  }

  // heightMenu(String? _layar) {
  //   switch (_layar) {
  //     case 'Screen 1':
  //       return 200;
  //     case 'Screen 2':
  //       return 400;
  //     default:
  //   }
  // }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      setState(() {
        _screen = screenDetect(context);
      });
    }
    var userProvider2 = Provider.of<UserProvider>(context, listen: false);
    var globalProvider = Provider.of<GlobalProvider>(context, listen: false);
    return Scaffold(
      body: Stack(
        children: [
          background(context, Color(0xFFffffff)),
          Stack(
            alignment: Alignment.topRight,
            children: [
              GestureDetector(
                onTap: () {
                  if (mounted) {
                    setState(() {
                      _showMenu = false;
                    });
                  }
                },
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: appBarWithLogo(
                          context, userProvider2.getusername.toString(), () {
                        if (mounted) {
                          setState(() {
                            _showMenu = !_showMenu;
                          });
                        }
                      }, () {
                        Navigator.pushNamed(context, '/profil');
                      },
                          userProvider2.getphoto.toString(),
                          _notifcationNotRead
                              .where((e) => e['status'] == "not read")
                              .toList()
                              .length
                              .toString(),
                          true),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CarouselSlider(
                        options: CarouselOptions(
                            aspectRatio: 1 / 1,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            viewportFraction: 1,
                            height: heightSlide(_screen)),
                        items: _listContent.map((e) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Image.network(
                                globalProvider.baseUrl + e['img'],
                                width: MediaQuery.of(context).size.width,
                                // height: 200,
                                fit: BoxFit.fill,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;

                                  return Container(
                                    color: Colors.white,
                                    child: SpinKitWave(
                                      color: Colors.blue.shade400,
                                      size: 30,
                                    ),
                                  );
                                },

                                // width: MediaQuery.of(context).size.width,
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 14, top: 14, bottom: 8),
                      child: Text(
                        'Materi Fisikamu',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        height: 450,
                        child: _listBab.length == 0
                            ? SpinKitWave(
                                color: Colors.blue.shade400,
                                size: 30,
                              )
                            : GridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 4,
                                // childAspectRatio: 1 / 1.3,
                                childAspectRatio: 1 / 1.2,
                                children: _listBab.map((data) {
                                  return menuIconBab(
                                      data['deskripsi'], data['icon'], () {
                                    Navigator.pushNamed(context, '/subBab',
                                        arguments: data);
                                  }, context);
                                }).toList(),
                              ),
                      ),
                    )
                  ],
                ),
              ),
              menuAppBar(context, _showMenu, _notifcationNotRead, () {
                if (mounted) {
                  setState(() {
                    _showMenu = false;
                  });
                }
              }, () {
                if (mounted) {
                  setState(() {
                    _showPopUp = true;
                  });
                }
              }),
            ],
          ),
          _showPopUp
              ? panelPopUp(context, "keluar dari akunmu?", [
                  buttonStyle1(
                      context, 70, 'Ya', Color(0xFFF6F5FF), Colors.black, () {
                    logOut(context);
                  }),
                  buttonStyle1(
                      context, 70, 'Tidak', Color(0xFFF6F5FF), Colors.black,
                      () {
                    if (mounted) {
                      setState(() {
                        _showPopUp = false;
                      });
                    }
                  }),
                ])
              : Container()
        ],
      ),
    );
  }
}
