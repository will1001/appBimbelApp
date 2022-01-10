import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

Widget boxJawaban(
    BuildContext context,
    String _option,
    String _mode,
    String _jawabanBenar,
    List _listJawaban,
    int _nomor,
    var _jawaban,
    var _pilihJawaban) {
  // print(_jawaban);
  // print(_mode);
  // print(_option);
  // print(_jawabanBenar);
  return Padding(
    padding: const EdgeInsets.only(top: 16),
    child: Opacity(
      opacity: _mode == "Pembahasan"
          ? _listJawaban[_nomor - 1] == _option
              ? _option == _jawabanBenar.toUpperCase()
                  ? 1
                  : 0.5
              : 1
          : 1,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: BoxDecoration(
            color: _mode == "Pembahasan"
                ? _option == _jawabanBenar.toUpperCase()
                    ? Color(0xffFFF9C2)
                    : Colors.white
                : _listJawaban[_nomor - 1] == _option
                    ? Color(0xffFFF9C2)
                    : Colors.white,
            border: Border.all(
                width: 1,
                color: _mode == "Pembahasan"
                    ? _option == _jawabanBenar.toUpperCase()
                        ? Color(0xffF09428)
                        : Color(0xffE5E5E5)
                    : _listJawaban[_nomor - 1] == _option
                        ? Color(0xffF09428)
                        : Color(0xffE5E5E5))),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: new BoxDecoration(
                          color: _mode == "Pembahasan"
                              ? _option == _jawabanBenar.toUpperCase()
                                  ? Color(0xffF09428)
                                  : Color(0xffE5E5E5)
                              : _listJawaban[_nomor - 1] == _option
                                  ? Color(0xffF09428)
                                  : Color(0xffE5E5E5),
                          shape: BoxShape.circle,
                        ),
                        child: Center(child: Text("$_option"))),
                  ),
                  Container(
                    width: 250,
                    child: _jawaban,
                  )
                  // TeXView(child: TeXViewDocument(r"""\(\frac{1}{2})\"""))
                ],
              ),
              _mode == "Pembahasan"
                  ? Container()
                  : GestureDetector(
                      onTap: _pilihJawaban,
                      child: Container(
                        color: Colors.transparent,
                        height: 30,
                      ),
                    )
            ],
          ),
        ),
      ),
    ),
  );
}
