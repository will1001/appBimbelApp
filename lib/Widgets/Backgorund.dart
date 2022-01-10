import 'package:flutter/material.dart';

Widget background(context,Color _color) {
  return Container(
    color: _color,
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
  );
}
