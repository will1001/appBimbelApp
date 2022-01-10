import 'dart:async';

import 'package:fisikamu/Provider/GlobalProvider.dart';
import 'package:fisikamu/Provider/UserProvider.dart';
import 'package:fisikamu/Widgets/AppBarWithLogo.dart';
import 'package:fisikamu/Widgets/BottomNav.dart';
import 'package:fisikamu/Widgets/BottomNav2.dart';
import 'package:fisikamu/Widgets/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../APIAction.dart';
import '../main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SubBabList extends StatefulWidget {
  const SubBabList({Key? key}) : super(key: key);

  @override
  _SubBabListState createState() => _SubBabListState();
}

class _SubBabListState extends State<SubBabList> {
  bool _showMenu = false;
  Map args = {};
  List _listSubBab = [];
  List _listVideoMateri = [];
  Timer? timer;
  int _notifData = 0;
  int _subSelected = 0;
  var userProvider;

  getSubBab(String _idBab) {
    getAPI('/subBab_soal?id_bab=$_idBab').then((res) {
      if (mounted) {
        setState(() {
          _listSubBab = res;
          getVideoMateri(res[0]['id']);
        });
      }
    });
  }

  getVideoMateri(String _idSubBab) {
    getAPI('/video_materi?id_sub_bab=$_idSubBab').then((res) {
      print(res);
      if (mounted) {
        setState(() {
          _listVideoMateri = res;
        });
      }
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
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      var arguments = (ModalRoute.of(context)!.settings.arguments as Map);
      if (mounted) {
        setState(() {
          args = arguments;
        });
      }
      getSubBab(arguments['id']);
    });
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

  convertTitle(String _title) {
    switch (_title) {
      case 'Termal':
        return 'Termodinamika';
      default:
        return _title;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var globalProvider = Provider.of<GlobalProvider>(context, listen: false);
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.chevron_left)),
                    // SvgPicture.asset(
                    //   "assets/images/Logo2.svg",
                    //   color: Colors.red,
                    //   width: 100,
                    // ),
                    Text(
                      convertTitle(args['deskripsi'].toString()),
                      style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: Color(0xffbfbfbf),
              ),
              Padding(
                padding: const EdgeInsets.all(11.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 32,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _listSubBab
                        .asMap()
                        .map((i, e) => MapEntry(
                            i,
                            Padding(
                              padding: const EdgeInsets.only(right: 11.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _subSelected = i;
                                  });
                                  getVideoMateri(e['id']);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Center(
                                      child: Text(
                                    e['deskripsi'],
                                    style: TextStyle(
                                      color: i == _subSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  )),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(33),
                                    color: i == _subSelected
                                        ? Color(0xffEE5454)
                                        : Color(0xffFCE5E5),
                                  ),
                                ),
                              ),
                            )))
                        .values
                        .toList(),
                  ),
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ListView(
                    children: _listVideoMateri
                        .where((e) => e["status"] == "publish")
                        .toList()
                        .map((e) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/detailsVideoMateri',
                              arguments: e);
                        },
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  globalProvider.baseUrl + '${e['thumbnail']}',
                              fit: BoxFit.fill,
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              placeholder: (context, url) => SpinKitWave(
                                color: Colors.blue.shade400,
                                size: 30,
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 30, left: 8),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: e["icon"] == ""
                                        ? Image.asset(
                                            'assets/images/logo apps.png',
                                            width: 43,
                                            height: 43,
                                          )
                                        : Image.network(
                                            globalProvider.baseUrl + e["icon"],
                                            width: 43,
                                            height: 43,
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: customText(
                                          context,
                                          e['judul'].toString().length > 55
                                              ? e['judul']
                                                      .toString()
                                                      .substring(0, 55) +
                                                  ". . ."
                                              : e['judul'],
                                          TextAlign.start,
                                          14,
                                          FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ))
            ],
          ),
          BottomNav2()
        ],
      ),
    );
  }
}
