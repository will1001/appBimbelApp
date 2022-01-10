import 'package:flutter/material.dart';

Widget buttonStyle1(BuildContext context, double _width, String _text,
    Color _colors, Color _fontColor, var _onTap) {
  return GestureDetector(
    onTap: _onTap,
    child: Container(
      height: 45,
      width: _width,
      decoration: BoxDecoration(
          color: _colors,
          border: Border.all(
              width: 1,
              color: _colors == Colors.white ? Color(0xffBFBFBF) : _colors)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          _text,
          style:
              TextStyle(color: _fontColor, fontFamily: "Nunito", fontSize: 16),
        )),
      ),
    ),
  );
}
