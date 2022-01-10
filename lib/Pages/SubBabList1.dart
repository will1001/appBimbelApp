import 'dart:async';

import 'package:fisikamu/Provider/GlobalProvider.dart';
import 'package:fisikamu/Provider/UserProvider.dart';
import 'package:fisikamu/Widgets/AppBarWithLogo.dart';
import 'package:fisikamu/Widgets/BottomNav.dart';
import 'package:fisikamu/Widgets/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var globalProvider = Provider.of<GlobalProvider>(context, listen: false);
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              ListView(
                children: [
                  appBarWithLogo(context, userProvider.getusername.toString(),
                      () {
                    if (mounted) {
                      setState(() {
                        _showMenu = !_showMenu;
                      });
                    }
                  }, () {
                    Navigator.pushNamed(context, '/profil');
                  }, userProvider.getphoto.toString(), _notifData.toString(),
                      false),
                  // Text(args.toString()),
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        // width: MediaQuery.of(context).size.width -
                        //     MediaQuery.of(context).size.width * 0.45,
                        // color: Colors.white,
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.4),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _listVideoMateri.map((e) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/detailsVideoMateri',
                                      arguments: e);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          // Container(
                                          //   width: 76,
                                          //   height: 45,
                                          //   color: Colors.black,
                                          // ),
                                          // Image.network(
                                          //     globalProvider.baseUrl +
                                          //         '${e['thumbnail']}',
                                          //     width: MediaQuery.of(context)
                                          //             .size
                                          //             .width *
                                          //         0.6,
                                          //     height: 100,
                                          //     fit: BoxFit.fill),
                                          CachedNetworkImage(
                                            imageUrl: globalProvider.baseUrl +
                                                '${e['thumbnail']}',
                                            fit: BoxFit.fill,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            height: 100,
                                            placeholder: (context, url) =>
                                                SpinKitWave(
                                              color: Colors.blue.shade400,
                                              size: 30,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                          Image.asset(
                                            'assets/images/PlayVideo.png',
                                            width: 16,
                                            height: 16,
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
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
                                              FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Container(
                        // height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height,
                        color: Color(0xFFE9ECEB),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _listSubBab
                                .asMap()
                                .map((i, e) => MapEntry(
                                    i,
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 8),
                                        width: MediaQuery.of(context)
                                                .size
                                                .width -
                                            MediaQuery.of(context).size.width *
                                                0.55,
                                        color: _subSelected == i
                                            ? Colors.white
                                            : Colors.transparent,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (mounted) {
                                              setState(() {
                                                _subSelected = i;
                                              });
                                            }
                                            getVideoMateri(e['id']);
                                          },
                                          child: customText(
                                              context,
                                              e['deskripsi'],
                                              TextAlign.start,
                                              16,
                                              _subSelected == i
                                                  ? FontWeight.w700
                                                  : FontWeight.w400),
                                        ),
                                      ),
                                    )))
                                .values
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          BottomNav()
        ],
      ),
    );
  }
}
