import 'package:fisikamu/Provider/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget customText(BuildContext context,String _text,TextAlign _textAlign,double _fontSize,FontWeight _fontWeight) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  return Text(_text,textAlign: _textAlign,style: TextStyle(
    fontFamily: themeProvider.fontFamily,
    fontSize: _fontSize,
    fontWeight: _fontWeight,
  ),);
}
