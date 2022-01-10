import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget Label(String _labelText,MainAxisAlignment _align) {
  return Row(
            mainAxisAlignment: _align,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_labelText),
              )
            ],
          );
}
