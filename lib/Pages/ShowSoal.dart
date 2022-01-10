import 'dart:async';
import 'dart:math' as math;
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
import 'package:flutter_tex/flutter_tex.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class ShowSoal extends StatefulWidget {
  const ShowSoal({Key? key}) : super(key: key);

  @override
  _ShowSoalState createState() => _ShowSoalState();
}

class _ShowSoalState extends State<ShowSoal> {
  String _baseUrl = "https://fisikamu.xyz";

  LatexMethods latexMethods = new LatexMethods();
  ScrollController _scrollController = new ScrollController();
  bool _showPembahasan = false;
  bool _showPopUp = false;
  bool _clicked = true;
  Map args = {};
  List _listSoal = [];
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
  int _renderfinish = 0;
  int _lineCntLength = 0;
  bool _timerFirstStart = true;
  String _pilihjwban = "";

  updateRenderProgress(int _inp) {
    if (mounted) {
      setState(() {
        _renderProgress += _inp;
      });
    }
  }

  getLineCntLength(int _inp) {
    // print("asdafasfsafaaff");
    // print(_inp);
    if (mounted) {
      setState(() {
        _lineCntLength = _inp;
        // _renderfinish += _inp * 4;
      });
    }
  }

  heightBaseNumberSoal(int _jmlSoal) {
    if (_jmlSoal <= 8) {
      return 150.0;
    } else if (_jmlSoal <= 16 && _jmlSoal >= 8) {
      return 200.0;
    } else if (_jmlSoal >= 17) {
      return 240.0;
    } else {
      return 150.0;
    }
  }

  paddingSoal(int _jmlSoal) {
    if (_jmlSoal <= 8) {
      return 10.0;
    } else if (_jmlSoal <= 16 && _jmlSoal >= 8) {
      return 20.0;
    } else if (_jmlSoal >= 17) {
      return 10.0;
    } else {
      return 15.0;
    }
  }

  heightBaseNumberSoalLayer(int _jmlSoal) {
    if (_jmlSoal <= 8) {
      return 50.0;
    } else if (_jmlSoal <= 16 && _jmlSoal >= 8) {
      return 100.0;
    } else if (_jmlSoal >= 17) {
      return 155.0;
    } else {
      return 120.0;
    }
  }

  skeletonLoadingWidget(int _numberBaris) {
    List _baris = List.filled(_numberBaris, 0);
    return SkeletonLoader(
      builder: Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Row(
          children: <Widget>[
            SizedBox(width: 10),
            Expanded(
              child: Column(
                children: _baris.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Container(
                      width: double.infinity,
                      height: 14,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      items: 1,
      period: Duration(seconds: 2),
      highlightColor: Colors.black54,
      direction: SkeletonDirection.ltr,
    );
  }

  latexView(String _soal, BuildContext context, String _option,
      var _skeletonLoading) {
    // print(latexMethods.translationLatexPreiview(
    //     latexMethods.translationLatex(_soal), _listSoal, _nomor, _linkImg));
    return latexMethods.translationLatexPreiview(
        latexMethods.translationLatex(_soal),
        // _soal,
        _listSoal,
        _nomor,
        _linkImg,
        context,
        updateRenderProgress,
        getLineCntLength,
        _option,
        args['mode'],
        _listSoal[_nomor - 1]['jawaban'],
        _listJawaban,
        _nomor,
        _skeletonLoading);
  }

  cekGbr(String _input) {
    RegExp imgRegex = RegExp(r'\img\d+');
    RegExp numberImagesRegex = RegExp(r'(?<=img)\d+');
    String text = "";
    List<TeXViewWidget> def = [];
    var a = _input.split(" ").toList();

    var abc = a.map((e) {
      return e;
    }).toList();

    for (var item in abc) {
      if (imgRegex.hasMatch(item)) {
        Iterable<Match> numberImages = numberImagesRegex.allMatches(item);

        def.add(TeXViewDocument(text));
        // def.add(TeXView(child: TeXViewDocument(text)));
        for (Match match in numberImages) {
          int index = int.parse(match.group(0).toString());
          def.add(
            _linkImg.length == 0
                ? TeXViewDocument("")
                : TeXViewContainer(
                    child: TeXViewImage.network(
                        _baseUrl + _linkImg[index]["deskripsi"]),
                    style: TeXViewStyle(
                      margin: TeXViewMargin.all(10),
                      borderRadius: TeXViewBorderRadius.all(20),
                    ),
                  ),
          );
        }

        text = "";
      } else {
        text += item + " ";
      }
    }
    def.add(TeXViewDocument(text));
    return TeXViewColumn(children: def.toList());
  }

  areaBoxJwb(String _id, String _text, bool _selectedHistory) {
    // print(args['mode']);
    // print(_id);
    // print("====");
    // print(_listSoal[_nomor - 1]['jawaban'].toUpperCase());
    // print(_listSoal[_nomor - 1]['jawaban'].toUpperCase() == _id);
    Color _bgColor = Colors.transparent;
    Color _borderColor = Colors.transparent;
    // // print(_clicked);
    // if (_selectedHistory && _clicked == false) {
    //   _bgColor = Color(0xffFFF9C2);
    //   _borderColor = Color(0xffF09428);
    //   // print("asdasfasf");

    //   // setState(() {
    //   //   _clicked = true;
    //   // });
    // }
    // setState(() {
    // _clicked = true;
    // });
    // if (_listJawaban[_nomor - 1] != _id && _clicked == false) {
    //   _bgColor = Colors.white;
    //   _borderColor = Color(0xffE5E5E5);
    // }
    // else {
    //   bgcolor = Colors.white;
    // }
    return TeXViewGroupItem(
        rippleEffect: false,
        id: _id,
        child: TeXViewDocument(latexMethods.translationLatex(_text),
            style: TeXViewStyle(
                height: 50,
                backgroundColor: args['mode'] == "Pembahasan"
                    ? _listJawaban[_nomor - 1] == _id
                        ? _listSoal[_nomor - 1]['jawaban'].toUpperCase() == _id
                            ? Colors.green
                            : Color(0xffFFF9C2)
                        : _listSoal[_nomor - 1]['jawaban'].toUpperCase() == _id
                            ? Colors.green
                            : Colors.white
                    : _listJawaban[_nomor - 1] == _id
                        ? Color(0xffFFF9C2)
                        : Colors.white,
                border: TeXViewBorder.all(TeXViewBorderDecoration(
                    borderWidth: 3,
                    borderColor: args['mode'] == "Pembahasan"
                        ? _id == _listSoal[_nomor - 1]['jawaban'].toUpperCase()
                            ? Color(0xffF09428)
                            : Color(0xffE5E5E5)
                        : _listJawaban[_nomor - 1] == _id
                            ? Color(0xffF09428)
                            : Color(0xffE5E5E5))),
                margin: TeXViewMargin.only(top: 8, bottom: 8),
                padding: TeXViewPadding.all(8))));
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
    if (_popUpMessage != "Waktu Habis" &&
        _popUpMessage != "kamu ingin membatalkan test ini?") {
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
    } else if (_popUpMessage == "kamu ingin membatalkan test ini?" &&
        _popUpMessage != "Waktu Habis") {
      widgetButton = [
        buttonStyle1(context, 70, 'Ya', Color(0xFFF6F5FF), Colors.black, () {
          Navigator.pop(context);
        }),
        buttonStyle1(context, 70, 'Tidak', Color(0xFFF6F5FF), Colors.black, () {
          if (mounted) {
            setState(() {
              _showPopUp = false;
            });
          }
        }),
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
      // Future.delayed(const Duration(milliseconds: 5000), () {
      //   if (mounted) {
      //     setState(() {
      //       _loading = false;
      //     });
      //   }

      // });
      startOrStopTimer();
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();

    if (args['mode'] == "Quiz") {
      if (mounted) {
        setState(() {
          _showPopUp = true;
          _popUpMessage = "kamu ingin membatalkan test ini?";
        });
      }
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    // if (_renderProgress == _renderProgress && _renderfinish <= 8) {
    //   setState(() {
    //     _renderfinish += 1;
    //   });
    // }
    // print("_renderProgress");
    // print(_renderProgress);
    // print("_renderfinish");
    // print(_renderfinish);
    // if (args['mode'] == "Quiz" && _renderfinish > 5 && _timerFirstStart) {
    //   startOrStopTimer();
    //   setState(() {
    //     _timerFirstStart = false;
    //   });
    // }
    return Scaffold(
      body: _listSoal.length == 0
          ? Loading()
          : WillPopScope(
              onWillPop: onWillPop,
              child: Stack(
                children: [
                  Stack(
                    children: [
                      background(context, Color(0xFFffffff)),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 0.0),
                                  child: ListView(
                                    controller: _scrollController,
                                    children: [
                                      // buttonStyle1(context, '_text', Colors.white, () {
                                      //   print(_listJawaban.toString());
                                      // }),
                                      // skeletonLoadingWidget(5),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 60,
                                        color: Colors.red[400],
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8, right: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "${args['data']['deskripsi']} ${(args['data']['tipe'] == "UTBK" ? "" : (_level))}",
                                                textAlign: TextAlign.end,
                                                style: GoogleFonts.nunito(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white),
                                              ),
                                              args['mode'] == "Quiz"
                                                  ? Text(
                                                      "$_jam : $_menit : $_detik",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: GoogleFonts.nunito(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: _listSoal.length == 0
                                            ? 0
                                            : heightBaseNumberSoalLayer(
                                                _listSoal.length),
                                        child: GridView.count(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          crossAxisCount: 8,
                                          childAspectRatio: 1 / 1,
                                          children: _listSoal
                                              .asMap()
                                              .map((i, e) => MapEntry(
                                                  i,
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (mounted) {
                                                          setState(() {
                                                            _nomor = i + 1;
                                                            _clicked = false;
                                                          });
                                                        }
                                                        loadImg(_listSoal[i]
                                                            ['id_soal']);
                                                      },
                                                      child: Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          Container(
                                                              width: 54,
                                                              height: 54,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Color(
                                                                        0xffE5E5E5)),
                                                                color: (i + 1 ==
                                                                        _nomor
                                                                    ? Color(
                                                                        0xFFFFF9C2)
                                                                    : args['mode'] ==
                                                                            "Quiz"
                                                                        ? _listJawaban[i] !=
                                                                                ""
                                                                            ? Color(
                                                                                0xFFF09428)
                                                                            : Colors
                                                                                .white
                                                                        : Colors
                                                                            .white),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                              ),
                                                              child: Center(
                                                                  child: Text(
                                                                      (i + 1)
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "Nunito",
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w400)))),
                                                          Opacity(
                                                              opacity: args[
                                                                          'mode'] ==
                                                                      "Quiz"
                                                                  ? 1
                                                                  : _listJawaban[i]
                                                                              .toString()
                                                                              .toUpperCase() ==
                                                                          _listSoal[i]['jawaban']
                                                                              .toString()
                                                                              .toUpperCase()
                                                                      ? 0
                                                                      : 1,
                                                              child: Opacity(
                                                                opacity:
                                                                    args['mode'] ==
                                                                            "Quiz"
                                                                        ? 0
                                                                        : 1,
                                                                child: Icon(
                                                                    Icons
                                                                        .clear),
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                  )))
                                              .values
                                              .toList(),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: _listSoal.length == 0
                                                ? 0
                                                : paddingSoal(_listSoal.length),
                                            bottom: 15,
                                            left: 15,
                                            right: 15),
                                        child: Container(
                                          color: Colors.white,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          // height: (_listSoal[_nomor - 1]['soal']
                                          //             .length /
                                          //         2) -
                                          //     1,
                                          child: TeXView(
                                              // renderingEngine:
                                              //     TeXViewRenderingEngine
                                              //         .katex(),
                                              // loadingWidgetBuilder:
                                              //     (BuildContext context) =>
                                              //         Container(),
                                              child: TeXViewColumn(children: [
                                            cekGbr(
                                                latexMethods.translationLatex(
                                                    _listSoal[_nomor - 1]
                                                        ['soal'])),
                                            // TeXViewDocument(
                                            //     latexMethods.translationLatex(
                                            //         _listSoal[_nomor - 1]
                                            //             ['soal'])),
                                            TeXViewGroup(
                                                // normalItemStyle: TeXViewStyle(
                                                //     margin: TeXViewMargin.only(
                                                //         top: 8, bottom: 8),
                                                //     padding:
                                                //         TeXViewPadding.all(8)),
                                                // selectedItemStyle: TeXViewStyle(
                                                //     margin: TeXViewMargin.only(
                                                //         top: 8, bottom: 8),
                                                //     padding:
                                                //         TeXViewPadding.all(8),
                                                //     backgroundColor:
                                                //         args['mode'] !=
                                                //                 "Pembahasan"
                                                //             ? Color(0xffFFF9C2)
                                                //             : Colors
                                                //                 .transparent,
                                                //     border: args['mode'] !=
                                                //             "Pembahasan"
                                                //         ? TeXViewBorder.all(
                                                //             TeXViewBorderDecoration(
                                                //                 borderWidth: 3,
                                                //                 borderColor: Color(
                                                //                     0xffF09428)))
                                                //         : TeXViewBorder.all(
                                                //             TeXViewBorderDecoration(
                                                //             borderWidth: 0,
                                                //           ))),
                                                children: [
                                                  areaBoxJwb(
                                                      "A",
                                                      "A. " +
                                                          _listSoal[_nomor - 1]
                                                              ['pil_a'],
                                                      _listJawaban[
                                                              _nomor - 1] ==
                                                          "A"),
                                                  areaBoxJwb(
                                                      "B",
                                                      "B. " +
                                                          _listSoal[_nomor - 1]
                                                              ['pil_b'],
                                                      _listJawaban[
                                                              _nomor - 1] ==
                                                          "B"),
                                                  areaBoxJwb(
                                                      "C",
                                                      "C. " +
                                                          _listSoal[_nomor - 1]
                                                              ['pil_c'],
                                                      _listJawaban[
                                                              _nomor - 1] ==
                                                          "C"),
                                                  areaBoxJwb(
                                                      "D",
                                                      "D. " +
                                                          _listSoal[_nomor - 1]
                                                              ['pil_d'],
                                                      _listJawaban[
                                                              _nomor - 1] ==
                                                          "D"),
                                                  areaBoxJwb(
                                                      "E",
                                                      "E. " +
                                                          _listSoal[_nomor - 1]
                                                              ['pil_e'],
                                                      _listJawaban[
                                                              _nomor - 1] ==
                                                          "E"),
                                                ],
                                                onTap: (id) {
                                                  if (args['mode'] !=
                                                      "Pembahasan") {
                                                    if (mounted) {
                                                      setState(() {
                                                        _clicked = true;
                                                        _listJawaban[
                                                            _nomor - 1] = id;
                                                      });
                                                    }
                                                  }
                                                })
                                          ])),
                                        ),
                                      ),
                                      // boxJawaban(
                                      //     context,
                                      //     "A",
                                      //     args['mode'],
                                      //     _listSoal[_nomor - 1]['jawaban'],
                                      //     _listJawaban,
                                      //     _nomor,
                                      //     latexView(
                                      //         nullStringReplacer(
                                      //             _listSoal[_nomor - 1]
                                      //                 ['pil_a']),
                                      //         context,
                                      //         "A",
                                      //         skeletonLoadingWidget(1)), () {
                                      //   if (mounted) {
                                      //     setState(() {
                                      //       _listJawaban[_nomor - 1] = 'A';
                                      //     });
                                      //   }
                                      // }),
                                      // boxJawaban(
                                      //     context,
                                      //     'B',
                                      //     args['mode'],
                                      //     _listSoal[_nomor - 1]['jawaban'],
                                      //     _listJawaban,
                                      //     _nomor,
                                      //    latexView(
                                      //         nullStringReplacer(
                                      //             _listSoal[_nomor - 1]
                                      //                 ['pil_b']),
                                      //         context,
                                      //         'B',
                                      //         skeletonLoadingWidget(1)), () {
                                      //   if (mounted) {
                                      //     setState(() {
                                      //       _listJawaban[_nomor - 1] = 'B';
                                      //     });
                                      //   }
                                      // }),
                                      // boxJawaban(
                                      //     context,
                                      //     'C',
                                      //     args['mode'],
                                      //     _listSoal[_nomor - 1]['jawaban'],
                                      //     _listJawaban,
                                      //     _nomor,
                                      //       latexView(
                                      //         nullStringReplacer(
                                      //             _listSoal[_nomor - 1]
                                      //                 ['pil_c']),
                                      //         context,
                                      //         'C',
                                      //         skeletonLoadingWidget(1)), () {
                                      //   if (mounted) {
                                      //     setState(() {
                                      //       _listJawaban[_nomor - 1] = 'C';
                                      //     });
                                      //   }
                                      // }),
                                      // boxJawaban(
                                      //     context,
                                      //     'D',
                                      //     args['mode'],
                                      //     _listSoal[_nomor - 1]['jawaban'],
                                      //     _listJawaban,
                                      //     _nomor,
                                      //     latexView(
                                      //         nullStringReplacer(
                                      //             _listSoal[_nomor - 1]
                                      //                 ['pil_d']),
                                      //         context,
                                      //         'C',
                                      //         skeletonLoadingWidget(1)), () {
                                      //   if (mounted) {
                                      //     setState(() {
                                      //       _listJawaban[_nomor - 1] = 'D';
                                      //     });
                                      //   }
                                      // }),
                                      // boxJawaban(
                                      //     context,
                                      //     'E',
                                      //     args['mode'],
                                      //     _listSoal[_nomor - 1]['jawaban'],
                                      //     _listJawaban,
                                      //     _nomor,
                                      //     latexView(
                                      //         nullStringReplacer(
                                      //             _listSoal[_nomor - 1]
                                      //                 ['pil_e']),
                                      //         context,
                                      //         'C',
                                      //         skeletonLoadingWidget(1)), () {
                                      //   if (mounted) {
                                      //     setState(() {
                                      //       _listJawaban[_nomor - 1] = 'E';
                                      //     });
                                      //   }
                                      // }),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 25.0, bottom: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0),
                                              child: Opacity(
                                                opacity: _nomor == 1 ? 0.5 : 1,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    if (_nomor != 1) {
                                                      if (mounted) {
                                                        setState(() {
                                                          _nomor -= 1;
                                                          _clicked = false;
                                                        });
                                                      }
                                                      loadImg(
                                                          _listSoal[_nomor - 1]
                                                              ['id_soal']);
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 45,
                                                    width: 45,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Color(
                                                              0xffBFBFBF)),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Image.asset(
                                                      "assets/images/left.png",
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Opacity(
                                              opacity: args['mode'] == 'Quiz'
                                                  ? 0.5
                                                  : 1,
                                              child: buttonStyle1(
                                                  context,
                                                  200,
                                                  'lihat pembahasan',
                                                  args['mode'] == 'Quiz'
                                                      ? Colors.white
                                                      : Color(0xffEE5454),
                                                  args['mode'] == 'Quiz'
                                                      ? Colors.black
                                                      : Colors.white, () {
                                                if (args['mode'] ==
                                                    'Pembahasan') {
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
                                                          ? MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .height
                                                          : -MediaQuery.of(
                                                                  context)
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 16.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (_nomor ==
                                                      _listSoal.length) {
                                                    if (args['mode'] ==
                                                        "Pembahasan") {
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
                                                  } else {
                                                    if (mounted) {
                                                      setState(() {
                                                        _nomor += 1;
                                                        _clicked = false;
                                                      });
                                                    }
                                                    loadImg(
                                                        _listSoal[_nomor - 1]
                                                            ['id_soal']);
                                                  }
                                                },
                                                child: Container(
                                                  height: 45,
                                                  width: 45,
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color:
                                                            Color(0xffBFBFBF)),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Image.asset(
                                                    "assets/images/fast-forward-double-right-arrows-symbol.png",
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      _showPembahasan
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 25.0, bottom: 25),
                                              child: TeXView(
                                                  // renderingEngine:
                                                  //     TeXViewRenderingEngine
                                                  //         .katex(),
                                                  style: TeXViewStyle(
                                                      padding:
                                                          TeXViewPadding.all(
                                                              8)),
                                                  child:
                                                      TeXViewColumn(children: [
                                                    cekGbr(latexMethods
                                                        .translationLatex(
                                                            _listSoal[
                                                                    _nomor - 1]
                                                                ['pembahasan']))
                                                  ])),
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                                // Expanded(
                                //   child: Container(
                                //     height:
                                //         100,
                                //     color: Colors.white,
                                //     child: Column(
                                //       crossAxisAlignment: CrossAxisAlignment.end,
                                //       children: [
                                //         Container(
                                //           width:
                                //               MediaQuery.of(context).size.width,
                                //           height: 60,
                                //           color: Colors.red[400],
                                //           child: Padding(
                                //             padding: const EdgeInsets.only(
                                //                 top: 8, right: 8),
                                //             child: Column(
                                //               crossAxisAlignment:
                                //                   CrossAxisAlignment.end,
                                //               children: [
                                //                 Text(
                                //                   "${args['data']['deskripsi']} ${(args['data']['tipe'] == "UTBK" ? "" : (_level))}",
                                //                   textAlign: TextAlign.end,
                                //                   style: GoogleFonts.nunito(
                                //                       fontSize: 16,
                                //                       fontWeight:
                                //                           FontWeight.w400,
                                //                       color: Colors.white),
                                //                 ),
                                //                 args['mode'] == "Quiz"
                                //                     ? Text(
                                //                         "$_jam : $_menit : $_detik",
                                //                         textAlign:
                                //                             TextAlign.start,
                                //                         style:
                                //                             GoogleFonts.nunito(
                                //                                 fontSize: 18,
                                //                                 fontWeight:
                                //                                     FontWeight
                                //                                         .bold,
                                //                                 color: Colors
                                //                                     .white),
                                //                       )
                                //                     : Container(),
                                //               ],
                                //             ),
                                //           ),
                                //         ),
                                //         Expanded(
                                //           child: SizedBox(
                                //             width:
                                //                 MediaQuery.of(context).size.width,
                                //             height: _listSoal.length == 0? 0 : heightBaseNumberSoalLayer(
                                //                 _listSoal.length),
                                //             child: GridView.count(
                                //               physics:
                                //                   NeverScrollableScrollPhysics(),
                                //               crossAxisCount: 8,
                                //               childAspectRatio: 1 / 1,
                                //               children: _listSoal
                                //                   .asMap()
                                //                   .map((i, e) => MapEntry(
                                //                       i,
                                //                       Padding(
                                //                         padding:
                                //                             const EdgeInsets.all(
                                //                                 8.0),
                                //                         child: GestureDetector(
                                //                           onTap: () {
                                //                             if (mounted) {
                                //                               setState(() {
                                //                                 _nomor = i + 1;
                                //                               });
                                //                             }
                                //                             loadImg(_listSoal[i]
                                //                                 ['id_soal']);
                                //                           },
                                //                           child: Stack(
                                //                             alignment:
                                //                                 Alignment.center,
                                //                             children: [
                                //                               Container(
                                //                                   width: 54,
                                //                                   height: 54,
                                //                                   padding:
                                //                                       EdgeInsets
                                //                                           .all(0),
                                //                                   decoration:
                                //                                       BoxDecoration(
                                //                                     border: Border.all(
                                //                                         width: 1,
                                //                                         color: Color(
                                //                                             0xffE5E5E5)),
                                //                                     color: (i + 1 ==
                                //                                             _nomor
                                //                                         ? Color(
                                //                                             0xFFFFF9C2)
                                //                                         : args['mode'] ==
                                //                                                 "Quiz"
                                //                                             ? _listJawaban[i] !=
                                //                                                     ""
                                //                                                 ? Color(
                                //                                                     0xFFF09428)
                                //                                                 : Colors
                                //                                                     .white
                                //                                             : Colors
                                //                                                 .white),
                                //                                     borderRadius:
                                //                                         BorderRadius
                                //                                             .circular(
                                //                                                 100),
                                //                                   ),
                                //                                   child: Center(
                                //                                       child: Text(
                                //                                           (i + 1)
                                //                                               .toString(),
                                //                                           style: TextStyle(
                                //                                               fontFamily:
                                //                                                   "Nunito",
                                //                                               fontSize:
                                //                                                   14,
                                //                                               fontWeight:
                                //                                                   FontWeight.w400)))),
                                //                               Opacity(
                                //                                   opacity: args[
                                //                                               'mode'] ==
                                //                                           "Quiz"
                                //                                       ? 1
                                //                                       : _listJawaban[i]
                                //                                                   .toString()
                                //                                                   .toUpperCase() ==
                                //                                               _listSoal[i]['jawaban']
                                //                                                   .toString()
                                //                                                   .toUpperCase()
                                //                                           ? 0
                                //                                           : 1,
                                //                                   child: Opacity(
                                //                                     opacity:
                                //                                         args['mode'] ==
                                //                                                 "Quiz"
                                //                                             ? 0
                                //                                             : 1,
                                //                                     child: Icon(
                                //                                         Icons
                                //                                             .clear),
                                //                                   ))
                                //                             ],
                                //                           ),
                                //                         ),
                                //                       )))
                                //                   .values
                                //                   .toList(),
                                //             ),
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          _showPopUp
                              ? panelPopUp(
                                  context, _popUpMessage, getButtonPopUp())
                              : Container()
                        ],
                      ),
                      // _loading ? Loading() : Container()
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
