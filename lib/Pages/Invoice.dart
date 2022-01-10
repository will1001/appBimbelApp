import 'dart:async';

import 'package:fisikamu/APIAction.dart';
import 'package:fisikamu/Widgets/Backgorund.dart';
import 'package:fisikamu/Widgets/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class Invoice extends StatefulWidget {
  const Invoice({Key? key}) : super(key: key);

  @override
  _InvoiceState createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  Map args = {};
  var formatter = NumberFormat.currency(locale: 'ID', name: "Rp.");
  Timer? _timer;
  int _jam = 0;
  int _menit = 0;
  int _detik = 0;
  List _dataAdmin = [];

  setWaktu(String _time, Map _dataInvoice) {
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

  sisaWaktu(DateTime from, DateTime to) {
    var diff = to.difference(from);
    var timeLeft = 24 * 3600 - diff.inSeconds;
    if (int.parse(timeLeft.toString()) < 0) timeLeft = 0;

    return (timeLeft.toString());
  }

  getNamaPaket(String _deskripsi) {
    String result = "";
    RegExp namaPaketRegex = RegExp(r'\"(.*?)\"');
    Iterable<Match> namaPaket = namaPaketRegex.allMatches(_deskripsi);
    for (Match match in namaPaket) {
      result = match.group(1)!;
    }
    return result;
  }

  getDataAdmin() {
    getAPI('/invoice_settings').then((res) {
      if (mounted) {
        setState(() {
          _dataAdmin = res;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getDataAdmin();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      var arguments = (ModalRoute.of(context)!.settings.arguments as Map);

      if (arguments['status'] == "Belum di Bayar") {
        if (arguments['created_at'] == null) {
          setWaktu(
              sisaWaktu(
                  DateTime.parse(DateTime.now().toString()), DateTime.now()),
              arguments);
        } else {
          setWaktu(
              sisaWaktu(DateTime.parse(arguments['created_at'].toString()),
                  DateTime.now()),
              arguments);
        }
        startOrStopTimer();
      }
      if (mounted) {
        setState(() {
          args = arguments;
        });
      }
      // print(arguments);
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
    return Scaffold(
      body: Stack(
        children: [
          background(context, Color(0xFFffffff)),
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Center(
                    child: SvgPicture.asset(
                  "assets/images/Logo2.svg",
                  width: 200,
                  color: Colors.red,
                )),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(16),
                child: args == {}
                    ? Center(child: CircularProgressIndicator())
                    : ListView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          // customText(context, "Status : ${args["status"]}",
                          //     TextAlign.left, 18, FontWeight.w600),
                          RichText(
                            text: TextSpan(
                                text: 'Nama Paket : ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w600),
                                children: [
                                  TextSpan(
                                    text: getNamaPaket(
                                        args["description"] == null
                                            ? ""
                                            : args["description"]),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.w600),
                                  ),
                                ]),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: RichText(
                              text: TextSpan(
                                  text: 'Harga : ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w600),
                                  children: [
                                    TextSpan(
                                      text: args["jumlah"] == null
                                          ? ""
                                          : '${formatter.format(int.parse(args["jumlah"]) + int.parse(args["kode_unik"]))}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ]),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: RichText(
                              text: TextSpan(
                                  text: 'Status : ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w600),
                                  children: [
                                    TextSpan(
                                      text: '${args["status"]}',
                                      style: TextStyle(
                                          color:
                                              args["status"] == "Belum di Bayar"
                                                  ? Colors.red.shade400
                                                  : Colors.green,
                                          fontSize: 18,
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ]),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: customText(
                                context,
                                "Silahkan Melakukan Pembayaran Ke",
                                TextAlign.left,
                                14,
                                FontWeight.w400),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Center(
                              child: customText(
                                  context,
                                  "${_dataAdmin.length == 0 ? "" : "${_dataAdmin[0]['bank']} ${_dataAdmin[0]['no_rek']}"}",
                                  TextAlign.left,
                                  17,
                                  FontWeight.w700),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                    text: 'a/n ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.w400),
                                    children: [
                                      TextSpan(
                                        text:
                                            '${_dataAdmin.length == 0 ? "" : _dataAdmin[0]['nama_rek'] ?? ""}',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(0),
                              child: customText(
                                  context,
                                  "Setelah melakukan pembayaran, admin kami akan melakukan verifikasi paling lambat 1x24 jam setelah pembayaran dilakukan.",
                                  TextAlign.justify,
                                  14,
                                  FontWeight.w400),
                            ),
                          ),
                          args["status"] == "Belum di Bayar"
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Center(
                                    child: customText(
                                        context,
                                        "Sisa Waktu Pembayaran :",
                                        TextAlign.left,
                                        17,
                                        FontWeight.w400),
                                  ),
                                )
                              : Container(),
                          args["status"] == "Belum di Bayar"
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Center(
                                    child: customText(
                                        context,
                                        "$_jam : $_menit : $_detik",
                                        TextAlign.left,
                                        22,
                                        FontWeight.w700),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
