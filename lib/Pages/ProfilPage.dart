import 'dart:async';
import 'dart:math';
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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';

import '../APIAction.dart';
import '../main.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> with TickerProviderStateMixin {
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
  var rng = new Random();
  late TabController _tabController;

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

  Widget subMenu(int? _index) {
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
    _tabController = TabController(length: 3, vsync: this);
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
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  padding: const EdgeInsets.only(top: 20),
                  color: Color(0xfff2a4a9),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                              )),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            circlePhotoProfile(
                                context,
                                userProvider.getphoto.toString(),
                                userProvider.getusername.toString()),
                            Text(
                              userProvider.getusername.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "Nunito",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
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
                        text: 'Profil',
                      ),
                      Tab(
                        text: 'Bantuan',
                      ),
                      Tab(
                        text: 'Paket',
                      )
                    ]),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 290.0),
              child: TabBarView(
                  controller: _tabController,
                  children: [0, 1, 2].map((e) => subMenu(e)).toList()),
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
              // padding: EdgeInsets.only(
              //     left: MediaQuery.of(context).size.width * 0.4 + 8),
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 0),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buttonStyle1(
                      context, 100, "edit profil", Colors.white, Colors.black,
                      () {
                    // print(_listUsersDetails);
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
      padding: const EdgeInsets.only(top: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // padding: EdgeInsets.only(
            //     left: MediaQuery.of(context).size.width * 0.4 + 4,
            //     top: 8,
            //     right: 8),
            padding: const EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            child: Form(
              key: formKey,
              child: InputText('Tulis Pertanyaanmu', false, 219, 10,
                  pertanyaanTextEditingController, (val) {
                return val.isEmpty || val.length < 2
                    ? "Tulis Pertanyaanmu"
                    : null;
              }, 0),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                buttonStyle1(context, 140, 'kirim pertanyaan',
                    Color(0xffEe5454), Colors.white, () {
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
                          buttonStyle1(context, 70, 'Tutup', Color(0xFFF6F5FF),
                              Colors.black, () {
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
          )
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
    return _listPaket.length == 0
        ? Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Container(
              height: 350,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/images/empty.svg',
                      width: 128,
                      height: 128,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Text("Kosong",
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff708AB1))),
                    )
                  ],
                ),
              ),
            ),
          )
        : Container(
            // padding:
            //     EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.4),
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView(
                children: _listPaket.length == 0
                    ? []
                    : _listPaket.map((e) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Color(0xffBFBFBF))),
                                  child: Html(data: e['deskripsi'])),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: buttonStyle1(context, 100, "Beli Paket",
                                  Color(0xffEe5454), Colors.white, () {
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
                                              context,
                                              70,
                                              'Ya',
                                              Color(0xFFF6F5FF),
                                              Colors.black, () {
                                            Map<String, String> dataPaket = {
                                              "id_user":
                                                  userProv.getid.toString(),
                                              "id_paket": e['id'],
                                              "payment_type": "Bank Transfer",
                                              "jumlah": e['harga'],
                                              "kode_unik":
                                                  rng.nextInt(999).toString(),
                                              "status": "Belum di Bayar",
                                              "description":
                                                  "Pembelian Paket \"${e['nama']}\"",
                                            };
                                            postAPI('/transaction_history',
                                                dataPaket);
                                            Navigator.pushNamed(
                                                context, '/invoice',
                                                arguments: dataPaket);
                                            if (mounted) {
                                              setState(() {
                                                _showPopUp = false;
                                              });
                                            }
                                          }),
                                          buttonStyle1(
                                              context,
                                              70,
                                              'Tidak',
                                              Color(0xFFF6F5FF),
                                              Colors.black, () {
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
                                            DateTime.parse(_invc[0]
                                                    ['created_at']
                                                .toString()),
                                            DateTime.now()))) ==
                                        0) {
                                      Map<String, String> data = {
                                        "id": _invc[0]['id'].toString(),
                                        "id_user":
                                            _invc[0]['id_user'].toString(),
                                        "id_paket":
                                            _invc[0]['id_paket'].toString(),
                                        "payment_type":
                                            _invc[0]['payment_type'].toString(),
                                        "jumlah": _invc[0]['jumlah'].toString(),
                                        "kode_unik":
                                            _invc[0]['kode_unik'].toString(),
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
                                                context,
                                                70,
                                                'Ya',
                                                Color(0xFFF6F5FF),
                                                Colors.black, () {
                                              Map<String, String> dataPaket = {
                                                "id_user":
                                                    userProv.getid.toString(),
                                                "id_paket": e['id'],
                                                "payment_type": "Bank Transfer",
                                                "jumlah": e['harga'],
                                                "kode_unik":
                                                    rng.nextInt(999).toString(),
                                                "status": "Belum di Bayar",
                                                "description":
                                                    "Pembelian Paket \"${e['nama']}\"",
                                              };
                                              postAPI('/transaction_history',
                                                  dataPaket);
                                              Navigator.pushNamed(
                                                  context, '/invoice',
                                                  arguments: dataPaket);
                                              if (mounted) {
                                                setState(() {
                                                  _showPopUp = false;
                                                });
                                              }
                                            }),
                                            buttonStyle1(
                                                context,
                                                70,
                                                'Tidak',
                                                Color(0xFFF6F5FF),
                                                Colors.black, () {
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
      child: Table(
        columnWidths: {
          0: FixedColumnWidth(55),
        },
        children: [
          TableRow(children: [
            Text(
              _text,
              style: TextStyle(fontSize: 16, fontFamily: "Nunito"),
            ),
            Text(
              "- $_value",
              style: TextStyle(fontSize: 16, fontFamily: "Nunito"),
            ),
          ])
        ],
      ),
    );
  }
}
