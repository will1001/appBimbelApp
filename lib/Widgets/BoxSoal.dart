import 'package:flutter/material.dart';

Widget boxSoal(BuildContext context, String _text) {
  return Padding(
    padding: const EdgeInsets.only(top: 16),
    child: Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      // height: 238,
      // child: latexView(nullStringReplacer(_listSoal[_nomor - 1]['soal'])),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(_text),
      ),
    ),
  );
}
