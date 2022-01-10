import 'dart:async';

import 'package:fisikamu/FunctionGroup.dart';
import 'package:fisikamu/Provider/UserProvider.dart';
import 'package:fisikamu/Widgets/AppBarWithLogo.dart';
import 'package:fisikamu/Widgets/Backgorund.dart';
import 'package:fisikamu/Widgets/ButtonStyle1.dart';
import 'package:fisikamu/Widgets/CirclePhotoProfile.dart';
import 'package:fisikamu/Widgets/CustomText.dart';
import 'package:fisikamu/Widgets/InputText.dart';
import 'package:fisikamu/Widgets/PanelPopUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';

import '../APIAction.dart';
import '../main.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  Timer? timer;
  List _listPaket = [];
  List _listUsersDetails = [];
  int _menuIndex = 0;
  bool _showMenu = false;
  bool _showPopUp = false;
  int _notifData = 0;
  double _bantuanButtonPosition = 245;
  final formKey = GlobalKey<FormState>();
  String? _popUpMessage;

  List<Widget> _widgetPopUpButton = [];

  var userProvider;

  List _fAQ = [];
  TextEditingController pertanyaanTextEditingController =
      new TextEditingController();
  List _leftMenu = [
    'Profil Saya',
    'Bantuan',
    // 'FAQ',
    // 'Kebijakan & Privasi',
    'Beli Paket',
    'Logout'
  ];

  widthProfilSaya(String _layar) {
    switch (_layar) {
      case 'Screen 1':
        return 0.45;
      case 'Screen 2':
        return 0.345;
      default:
    }
  }

  widthBantuan(String _layar) {
    switch (_layar) {
      case 'Screen 1':
        return 0.5;
      case 'Screen 2':
        return 0.389;
      default:
    }
  }

  widthFAQ(String _layar) {
    switch (_layar) {
      case 'Screen 1':
        return 0.46;
      case 'Screen 2':
        return 0.35;
      default:
    }
  }

  widthKebijakan(String _layar) {
    switch (_layar) {
      case 'Screen 1':
        return 0.45;
      case 'Screen 2':
        return 0.34;
      default:
    }
  }

  widthPaket(String _layar) {
    switch (_layar) {
      case 'Screen 1':
        return 0.45;
      case 'Screen 2':
        return 0.343;
      default:
    }
  }

  sisaWaktu(DateTime from, DateTime to) {
    var diff = to.difference(from);
    var timeLeft = 24 * 3600 - diff.inSeconds;
    if (int.parse(timeLeft.toString()) < 0) timeLeft = 0;

    return (timeLeft.toString());
  }

  subMenu(int? _index) {
    switch (_index) {
      case 0:
        return profilSaya();
      case 1:
        return bantuan();
      // case 2:
      //   return fAQ();
      // case 3:
      //   return kebijakanPrivasi();
      case 2:
        return beliPaket();
      default:
        return Container();
    }
  }

  getUsersDetails(String _idUser) {
    getAPI('/users_details?id_user=$_idUser').then((res) {
      if (mounted) {
        setState(() {
          _listUsersDetails = res;
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

  getPaketApp() {
    getAPI('/paket_app').then((res) {
      if (mounted) {
        setState(() {
          _listPaket = res;
        });
      }
    });
  }

  Future<bool> onWillPop() {
    if (_showPopUp) {
      if (mounted) {
        setState(() {
          _showPopUp = false;
        });
      }
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  getFAQ() {
    getAPI('/faq').then((res) {
      if (mounted) {
        setState(() {
          _fAQ = res;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
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
    getFAQ();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // if (mounted){setState(() {
    //   _screen = screenDetect(context);
    // });
    return Scaffold(
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Stack(
          children: [
            background(context, Color(0xFFE5E5E5)),
            Stack(
              alignment: Alignment.center,
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
                    Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        _menuIndex == 5 ? Container() : subMenu(_menuIndex),
                        Container(
                          color: Color(0xFFE9ECEB),
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height,
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    circlePhotoProfile(
                                        context,
                                        userProvider.getphoto.toString(),
                                        userProvider.getusername.toString()),
                                    customText(
                                        context,
                                        userProvider.getusername.toString(),
                                        TextAlign.center,
                                        14,
                                        FontWeight.w400),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 50.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: _leftMenu
                                        .asMap()
                                        .map((i, e) => MapEntry(
                                            i,
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6),
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (i == 3) {
                                                    if (mounted) {
                                                      setState(() {
                                                        _showPopUp = true;
                                                        _popUpMessage =
                                                            "Apakah kamu yakin akan keluar dari akunmu?";
                                                        _widgetPopUpButton = [
                                                          buttonStyle1(
                                                              context,
                                                              70,
                                                              'Ya',
                                                              Color(0xFFF6F5FF),Colors.black,
                                                              () {
                                                            logOut(context);
                                                          }),
                                                          buttonStyle1(
                                                              context,
                                                              70,
                                                              'Tidak',
                                                              Color(0xFFF6F5FF),Colors.black,
                                                              () {
                                                            if (mounted) {
                                                              setState(() {
                                                                _showPopUp =
                                                                    false;
                                                              });
                                                            }
                                                          }),
                                                        ];
                                                      });
                                                    }
                                                  } else {
                                                    if (mounted) {
                                                      setState(() {
                                                        _menuIndex = i;
                                                      });
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 8),
                                                  color: _menuIndex == i
                                                      ? _menuIndex == 5
                                                          ? Colors.transparent
                                                          : Colors.white
                                                      : Colors.transparent,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  child: customText(
                                                      context,
                                                      e,
                                                      TextAlign.left,
                                                      _menuIndex == i ? 16 : 14,
                                                      _menuIndex == i
                                                          ? FontWeight.w700
                                                          : FontWeight.w400),
                                                ),
                                              ),
                                            )))
                                        .values
                                        .toList(),
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
                _showPopUp
                    ? panelPopUp(
                        context, _popUpMessage.toString(), _widgetPopUpButton)
                    : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget profilSaya() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    getUsersDetails(userProvider.getid.toString());
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.4 + 8),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  profilListParams(
                      'Nama',
                      _listUsersDetails.length == 0
                          ? ""
                          : _listUsersDetails[0]['username'].toString()),
                  profilListParams(
                      'Email',
                      _listUsersDetails.length == 0
                          ? ""
                          : _listUsersDetails[0]['email'].toString()),
                  profilListParams(
                      'WA',
                      _listUsersDetails.length == 0
                          ? ""
                          : _listUsersDetails[0]['no_hp'].toString()),
                  profilListParams(
                      'Alamat',
                      _listUsersDetails.length == 0
                          ? ""
                          : _listUsersDetails[0]['alamat'].toString()),
                  profilListParams(
                      'Status',
                      _listUsersDetails.length == 0
                          ? ""
                          : _listUsersDetails[0]['membership']
                              .toString()
                              .toUpperCase()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  buttonStyle1(context, 100, "edit profil", Colors.white,Colors.black, () {
                    Navigator.pushNamed(context, '/formEditProfil',
                        arguments: _listUsersDetails[0]);
                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget bantuan() {
    final userProv = Provider.of<UserProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.4 + 4,
                    top: 8,
                    right: 8),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: formKey,
                  child: InputText('Tulis Pertanyaanmu', false, 219, 10,
                      pertanyaanTextEditingController, (val) {
                    return val.isEmpty || val.length < 2
                        ? "Tulis Pertanyaan  Anda"
                        : null;
                  }, 0),
                ),
              ),
            ],
          ),
          Positioned(
            top: _bantuanButtonPosition,
            right: 8,
            child: Row(
              children: [
                buttonStyle1(context, 130, 'kirim pertanyaan', Colors.white,Colors.black,
                    () {
                  if (formKey.currentState!.validate()) {
                    Map<String, String> dataBantuan = {
                      "id_user": userProv.getid.toString(),
                      "pertanyaan": pertanyaanTextEditingController.text,
                    };
                    postAPI('/bantuan', dataBantuan);
                    if (mounted) {
                      setState(() {
                        pertanyaanTextEditingController.text = "";
                      });
                    }
                    if (mounted) {
                      setState(() {
                        _showPopUp = true;
                        _popUpMessage =
                            "Pertanyaanmu sudah kami terima, tunggu respon dari kami ya";

                        _widgetPopUpButton = [
                          buttonStyle1(context, 70, 'Tutup', Color(0xFFF6F5FF),Colors.black,
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

                    if (mounted) {
                      setState(() {
                        _bantuanButtonPosition = 245;
                      });
                    }
                  } else {
                    if (mounted) {
                      setState(() {
                        _bantuanButtonPosition = 265;
                      });
                    }
                  }
                })
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget fAQ() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.4),
      child: ListView.builder(
        // scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: _fAQ.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ExpansionTile(
                title: Text(
                  _fAQ[index]['pertanyaan'],
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                ),
                children: <Widget>[
                  ListTile(
                    title: Text(
                      _fAQ[index]['jawaban'],
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget kebijakanPrivasi() {
    return Container(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.4),
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Kebijakan Privasi"),
        ));
  }

  Widget beliPaket() {
    getPaketApp();
    final userProv = Provider.of<UserProvider>(context, listen: false);
    return Container(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.4),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView(
          children: _listPaket.length == 0
              ? []
              : _listPaket.map((e) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(8),
                          child: Html(data: e['deskripsi'])),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 16),
                        child: buttonStyle1(
                            context, 100, "Beli Paket", Colors.white,Colors.black, () {
                          getAPI('/transaction_history?id_user=${userProv.getid.toString()}&id_paket=${e['id']}')
                              .then((res) {
                            List _invc = res;
                            _invc = _invc
                                .where((e) => e['status'] != "Expired")
                                .toList();
                            // print(_invc);
                            // print(int.parse((sisaWaktu(
                            //         DateTime.parse(
                            //             _invc[0]['created_at'].toString()),
                            //         DateTime.now()))) ==
                            //     0);

                            if (_invc.length == 0) {
                              if (mounted) {
                                setState(() {
                                  _showPopUp = true;
                                  _popUpMessage =
                                      "Apakah kamu akan membeli Paket ${e['nama']} ?";

                                  _widgetPopUpButton = [
                                    buttonStyle1(
                                        context, 70, 'Ya', Color(0xFFF6F5FF),Colors.black,
                                        () {
                                      Map<String, String> dataPaket = {
                                        "id_user": userProv.getid.toString(),
                                        "id_paket": e['id'],
                                        "payment_type": "Bank Transfer",
                                        "jumlah": e['harga'],
                                        "status": "Belum di Bayar",
                                        "description":
                                            "Pembelian Paket \"${e['nama']}\"",
                                      };
                                      postAPI(
                                          '/transaction_history', dataPaket);
                                      Navigator.pushNamed(context, '/invoice',
                                          arguments: dataPaket);
                                     if(mounted){
                                        setState(() {
                                        _showPopUp = false;
                                      });
                                     }
                                    }),
                                    buttonStyle1(
                                        context, 70, 'Tidak', Color(0xFFF6F5FF),Colors.black,
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
                            } else {
                              if (int.parse((sisaWaktu(
                                      DateTime.parse(
                                          _invc[0]['created_at'].toString()),
                                      DateTime.now()))) ==
                                  0) {
                                Map<String, String> data = {
                                  "id": _invc[0]['id'].toString(),
                                  "id_user": _invc[0]['id_user'].toString(),
                                  "id_paket": _invc[0]['id_paket'].toString(),
                                  "payment_type":
                                      _invc[0]['payment_type'].toString(),
                                  "jumlah": _invc[0]['jumlah'].toString(),
                                  "status": "Expired",
                                  "description":
                                      _invc[0]['description'].toString(),
                                };
                                putAPI('/transaction_history', data);
                                if (mounted) {
                                  setState(() {
                                    _showPopUp = true;
                                    _popUpMessage =
                                        "Apakah kamu akan membeli Paket ${e['nama']} ?";

                                    _widgetPopUpButton = [
                                      buttonStyle1(
                                          context, 70, 'Ya', Color(0xFFF6F5FF),Colors.black,
                                          () {
                                        Map<String, String> dataPaket = {
                                          "id_user": userProv.getid.toString(),
                                          "id_paket": e['id'],
                                          "payment_type": "Bank Transfer",
                                          "jumlah": e['harga'],
                                          "status": "Belum di Bayar",
                                          "description":
                                              "Pembelian Paket \"${e['nama']}\"",
                                        };
                                        postAPI(
                                            '/transaction_history', dataPaket);
                                        Navigator.pushNamed(context, '/invoice',
                                            arguments: dataPaket);
                                        if(mounted){
                                          setState(() {
                                          _showPopUp = false;
                                        });
                                        }
                                      }),
                                      buttonStyle1(context, 70, 'Tidak',
                                          Color(0xFFF6F5FF),Colors.black, () {
                                        if (mounted) {
                                          setState(() {
                                            _showPopUp = false;
                                          });
                                        }
                                      }),
                                    ];
                                  });
                                }
                              } else {
                                Navigator.pushNamed(context, '/invoice',
                                    arguments: _invc[0]);
                              }
                            }
                          });
                        }),
                      )
                    ],
                  );
                }).toList()),
    );
  }

  Widget profilListParams(String _text, String _value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: RichText(
        text: TextSpan(
            text: '$_text ',
            style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w400),
            children: [
              TextSpan(
                text: '- $_value',
                style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700),
              )
            ]),
      ),
    );
  }
}
