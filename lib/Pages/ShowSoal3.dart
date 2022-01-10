import 'dart:async';

import 'package:fisikamu/APIAction.dart';
import 'package:fisikamu/FunctionGroup.dart';
import 'package:fisikamu/Widgets/Backgorund.dart';
import 'package:fisikamu/Widgets/BoxJawaban.dart';
import 'package:fisikamu/Widgets/ButtonStyle1.dart';
import 'package:fisikamu/Widgets/CustomText.dart';
import 'package:fisikamu/Widgets/Loading.dart';
import 'package:fisikamu/Widgets/PanelPopUp.dart';
import 'package:fisikamu/services/Latex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class ShowSoal extends StatefulWidget {
  const ShowSoal({Key? key}) : super(key: key);

  @override
  _ShowSoalState createState() => _ShowSoalState();
}

class _ShowSoalState extends State<ShowSoal> {
  LatexMethods latexMethods = new LatexMethods();
  ScrollController _scrollController = new ScrollController();
  bool _showPembahasan = false;
  bool _showPopUp = false;
  bool _firstCache = true;
  Map args = {};
  List _listSoal = [];
  List _listSoalCache = [];
  List _listJawaban = [];
  List _linkImg = [];
  int _nomor = 1;
  String _level = "";
  String _popUpMessage = "";
  int _jam = 0;
  int _menit = 0;
  int _detik = 0;
  Timer? _timer;
  bool _loading = true;
  int _renderProgress = 0;
  int _lineCntLength = 0;

   skeletonLoadingWidget() {
    return SkeletonLoader(
      builder: Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Row(
          children: <Widget>[
            SizedBox(width: 10),
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 10,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 12,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 12,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 12,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 12,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      items: 1,
      period: Duration(seconds: 2),
      highlightColor: Colors.lightBlue,
      direction: SkeletonDirection.ltr,
    );
  }

  updateRenderProgress(int _inp) {
    setState(() {
      _renderProgress += _inp;
    });
  }

  getLineCntLength(_inp) {
    setState(() {
      _lineCntLength = _inp;
    });
  }

  latexView(String _soal, BuildContext context,var _skeletonLoading) {
    // print(latexMethods.translationLatexPreiview(
    //     latexMethods.translationLatex(_soal), _listSoal, _nomor, _linkImg));
    return latexMethods.translationLatexPreiview(
        latexMethods.translationLatex(_soal),
        _listSoal,
        _nomor,
        _linkImg,
        context,
        updateRenderProgress,
        getLineCntLength,
        "A",
        args['mode'],
        _listSoal[_nomor - 1]['jawaban'],
        _listJawaban,
        _nomor,_skeletonLoading);
  }

  addListCache() {
    setState(() {
      _listSoalCache.add({
        "soal": Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 238,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: latexView(
                      nullStringReplacer(_listSoal[_nomor - 1]['soal']),
                      context,skeletonLoadingWidget()),
                )
              ],
            ),
          ),
        ),
        "jwbA": boxJawaban(
            context,
            "A",
            args['mode'],
            _listSoal[_nomor - 1]['jawaban'],
            _listJawaban,
            _nomor,
            latexView(
                nullStringReplacer(_listSoal[_nomor - 1]['pil_a']), context,skeletonLoadingWidget()),
            () {
          if (mounted) {
            setState(() {
              _listJawaban[_nomor - 1] = 'A';
            });
          }
        }),
        "jwbB": boxJawaban(
            context,
            'B',
            args['mode'],
            _listSoal[_nomor - 1]['jawaban'],
            _listJawaban,
            _nomor,
            latexView(
                nullStringReplacer(_listSoal[_nomor - 1]['pil_b']), context,skeletonLoadingWidget()),
            () {
          if (mounted) {
            setState(() {
              _listJawaban[_nomor - 1] = 'B';
            });
          }
        }),
        "jwbC": boxJawaban(
            context,
            'C',
            args['mode'],
            _listSoal[_nomor - 1]['jawaban'],
            _listJawaban,
            _nomor,
            latexView(
                nullStringReplacer(_listSoal[_nomor - 1]['pil_c']), context,skeletonLoadingWidget()),
            () {
          if (mounted) {
            setState(() {
              _listJawaban[_nomor - 1] = 'C';
            });
          }
        }),
        "jwbD": boxJawaban(
            context,
            'D',
            args['mode'],
            _listSoal[_nomor - 1]['jawaban'],
            _listJawaban,
            _nomor,
            latexView(
                nullStringReplacer(_listSoal[_nomor - 1]['pil_d']), context,skeletonLoadingWidget()),
            () {
          if (mounted) {
            setState(() {
              _listJawaban[_nomor - 1] = 'D';
            });
          }
        }),
        "jwbE": boxJawaban(
            context,
            'E',
            args['mode'],
            _listSoal[_nomor - 1]['jawaban'],
            _listJawaban,
            _nomor,
            latexView(
                nullStringReplacer(_listSoal[_nomor - 1]['pil_e']), context,skeletonLoadingWidget()),
            () {
          if (mounted) {
            setState(() {
              _listJawaban[_nomor - 1] = 'E';
            });
          }
        }),
      });
    });
  }

  saveCahedRender() {
    if (_listSoalCache.length > _nomor && _firstCache == false) {
      print("asdfxxx = ${_listSoalCache[_nomor - 1]}");
      if (_listSoalCache[_nomor - 1] != null) {
        addListCache();
      }
    } else {
      addListCache();
    }
  }

  getIsiPaketSoal(String _idPaket, var _jawabanTersimpan) {
    getAPIbyParam('/isi_paket_soal', '?id=$_idPaket').then((res) {
      loadImg(res[0]['id_soal']);
      if (mounted) {
        setState(() {
          _listSoal = res;
          args['mode'] == "Pembahasan"
              ? _listJawaban = _jawabanTersimpan
              : _listJawaban = List.filled(res.length, "");
        });
      }
    });
  }

  getButtonPopUp() {
    var widgetButton;
    if (_popUpMessage != "Waktu Habis") {
      widgetButton = [
        Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: buttonStyle1(
              context, 100, 'Ya', Color(0xFFF6F5FF), Colors.black, () {
            hitungNilai();
          }),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: buttonStyle1(
              context, 100, 'Tidak', Color(0xFFF6F5FF), Colors.black, () {
            startOrStopTimer();
            if (mounted) {
              setState(() {
                _showPopUp = false;
              });
            }
          }),
        )
      ];
    } else {
      widgetButton = [
        buttonStyle1(
            context, 100, 'Lihat Nilai', Color(0xFFF6F5FF), Colors.black, () {
          hitungNilai();
        }),
      ];
    }

    return widgetButton;
  }

  menuTryout() {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  hitungNilai() {
    double nilai = 0;
    int soalSalah = 0;

    if (mounted) {
      setState(() {
        _showPopUp = false;
      });
    }

    for (var i = 0; i < _listJawaban.length; i++) {
      if (_listJawaban[i].toUpperCase() ==
          _listSoal[i]['jawaban'].toUpperCase()) {
        nilai += 1;
      } else {
        soalSalah += 1;
      }
    }
    nilai = (nilai / _listSoal.length) * 100;
    // nilai = nilai.toStringAsPrecision(1);

    // print(nilai.toStringAsFixed(0));

    Navigator.pushNamed(context, '/hasilUjian', arguments: {
      'data': args['data'],
      'nilai': nilai.toStringAsFixed(0),
      'soal_salah': soalSalah,
      'jawaban': _listJawaban
    });
  }

  getLevel(String _idLevel) {
    getAPIbyParam('/tingkat_kesulitan', '?id=$_idLevel').then((res) {
      if (mounted) {
        setState(() {
          _level = res[0]['deskripsi'];
        });
      }
    });
  }

  loadImg(String _idSoal) {
    getAPIbyParam('/gambar_soal', '?id_soal=$_idSoal').then((res) {
      if (mounted) {
        setState(() {
          _linkImg = res;
        });
      }
    });
  }

  setWaktu(String _time) {
    int waktu = int.parse(_time);
    if (mounted) {
      setState(() {
        _jam = (waktu / 3600).floor();
        waktu = waktu % 3600;
        _menit = (waktu / 60).floor();
        waktu = waktu % 60;
        _detik = waktu;
      });
    }
  }

  void startOrStopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    } else {
      _timer = new Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => setState(
          () {
            if (_detik < 1) {
              if (_menit != 0) {
                _menit -= 1;
                _detik = 59;
              } else {
                if (_jam != 0) {
                  _jam -= 1;
                  _menit = 59;
                  _detik = 59;
                } else {
                  // print("$_jam:$_menit:$_detik");
                  if (mounted) {
                    setState(() {
                      _showPopUp = true;
                      _popUpMessage = 'Waktu Habis';
                    });
                  }
                  timer.cancel();
                }
              }
            } else {
              _detik -= 1;
            }
          },
        ),
      );
    }
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
      // print(arguments);
      getIsiPaketSoal(arguments['data']['id'], arguments['jawaban']);
      getLevel(arguments['data']['id_level']);
      setWaktu(arguments['data']['waktu']);
      Future.delayed(const Duration(milliseconds: 5000), () {
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
        if (arguments['mode'] == "Quiz") {
          startOrStopTimer();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_listSoal.length != 0 && _firstCache) {
      saveCahedRender();
      setState(() {
        _firstCache = false;
      });
    }
    return Scaffold(
      body: _listSoal.length == 0
          ? Loading()
          : Stack(
              children: [
                Stack(
                  children: [
                    background(context, Color(0xFFE5E5E5)),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 15),
                          child: ListView(
                            controller: _scrollController,
                            children: [
                              // buttonStyle1(context, '_text', Colors.white, () {
                              //   print(_listJawaban.toString());
                              // }),

                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 100,
                                child: GridView.count(
                                  crossAxisCount: 9,
                                  childAspectRatio: 1 / 1,
                                  children: _listSoal
                                      .asMap()
                                      .map((i, e) => MapEntry(
                                          i,
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                if (mounted) {
                                                  setState(() {
                                                    _nomor = i + 1;
                                                  });
                                                }
                                                loadImg(
                                                    _listSoal[i]['id_soal']);
                                                saveCahedRender();
                                              },
                                              child: Container(
                                                  width: 34,
                                                  height: 34,
                                                  decoration: BoxDecoration(
                                                    color: (i + 1 == _nomor
                                                        ? Color(0xFFE9ECEB)
                                                        : Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                          (i + 1).toString()))),
                                            ),
                                          )))
                                      .values
                                      .toList(),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  customText(
                                      context,
                                      "${args['data']['deskripsi']} ${(args['data']['tipe'] == "UTBK" ? "" : (_level))}",
                                      TextAlign.end,
                                      16,
                                      FontWeight.w400),
                                  args['mode'] == "Quiz"
                                      ? customText(
                                          context,
                                          "$_jam : $_menit : $_detik",
                                          TextAlign.start,
                                          16,
                                          FontWeight.w400)
                                      : Container(),
                                ],
                              ),

                              _listSoalCache.length == 0
                                  ? SpinKitWave(
                                      color: Colors.blue.shade400,
                                      size: 30,
                                    )
                                  : _listSoalCache[_nomor - 1]["soal"],
                              // : Stack(
                              //     children: _listSoalCache
                              //         .asMap()
                              //         .map((i, e) => MapEntry(
                              //             i,
                              //             Opacity(
                              //               opacity:
                              //                   _nomor == i + 1 ? 1 : 0,
                              //               child: e["soal"],
                              //             )))
                              //         .values
                              //         .toList(),
                              //   ),

                              Padding(
                                padding: const EdgeInsets.only(top: 25.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Opacity(
                                      opacity: args['mode'] == 'Quiz' ? 0.5 : 1,
                                      child: buttonStyle1(
                                          context,
                                          100,
                                          'Pembahasan',
                                          Colors.white,
                                          Colors.black, () {
                                        if (args['mode'] == 'Pembahasan') {
                                          if (mounted) {
                                            setState(() {
                                              _showPembahasan =
                                                  !_showPembahasan;
                                            });
                                          }
                                          Future.delayed(
                                              const Duration(
                                                  milliseconds: 2000),
                                              () async {
                                            _scrollController.animateTo(
                                              _showPembahasan
                                                  ? MediaQuery.of(context)
                                                      .size
                                                      .height
                                                  : -MediaQuery.of(context)
                                                      .size
                                                      .height,
                                              curve: Curves.easeOut,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                            );
                                          });
                                        }
                                      }),
                                    ),
                                    Opacity(
                                      opacity: _nomor == 1 ? 0.5 : 1,
                                      child: buttonStyle1(
                                          context,
                                          100,
                                          'Sebelumnya',
                                          Colors.white,
                                          Colors.black, () {
                                        if (_nomor != 1) {
                                          if (mounted) {
                                            setState(() {
                                              _nomor -= 1;
                                            });
                                          }
                                          loadImg(
                                              _listSoal[_nomor - 1]['id_soal']);
                                        }
                                      }),
                                    ),
                                    _nomor == _listSoal.length
                                        ? buttonStyle1(context, 100, 'Selesai',
                                            Colors.white, Colors.black, () {
                                            if (args['mode'] == "Pembahasan") {
                                              menuTryout();
                                            } else {
                                              startOrStopTimer();
                                              if (mounted) {
                                                setState(() {
                                                  _showPopUp = true;
                                                  _popUpMessage =
                                                      'Apakah kamu yakin akan mengakhiri test ini?';
                                                });
                                              }
                                            }
                                          })
                                        : buttonStyle1(
                                            context,
                                            100,
                                            'Selanjutnya',
                                            Colors.white,
                                            Colors.black, () {
                                            if (mounted) {
                                              setState(() {
                                                _nomor += 1;
                                              });
                                            }
                                            loadImg(_listSoal[_nomor - 1]
                                                ['id_soal']);
                                          }),
                                  ],
                                ),
                              ),
                              _showPembahasan
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 25.0),
                                      child: Container(
                                        color: Colors.white,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 300,
                                        // decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.circular(10),
                                        //     border: Border.all(color: Colors.black)),
                                        child: ListView(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: latexView(
                                                  _listSoal[_nomor - 1]
                                                      ["pembahasan"],
                                                  context,skeletonLoadingWidget()),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                        _showPopUp
                            ? panelPopUp(
                                context, _popUpMessage, getButtonPopUp())
                            : Container()
                      ],
                    ),
                    _loading ? Loading() : Container()
                  ],
                ),
              ],
            ),
    );
  }
}
