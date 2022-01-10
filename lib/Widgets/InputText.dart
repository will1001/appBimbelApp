import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget InputText(
    String _labelText,
    bool _obscureText,
    double _height,
    int _maxlines,
    TextEditingController _controller,
    var _validator,
    double _padding) {
  return Padding(
    padding: EdgeInsets.all(_padding),
    child: Container(
      height: _height,
      width: 10,
      child: TextFormField(
        validator: _validator,
        controller: _controller,
        obscureText: _obscureText,
        // minLines: 1,
        maxLines: _maxlines,
        // cursorWidth: 12,

        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: _labelText,
            alignLabelWithHint: true
            // hintText: "asfasf"

            // labelStyle: texts
            // hintText: "Asfasf"
            // labelStyle: textst,
            // isDense: true,
            // contentPadding:
            //     EdgeInsets.symmetric(vertical: _height, horizontal: 10.0)
            // contentPadding: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, _height),
            ),
      ),
    ),
  );
}
