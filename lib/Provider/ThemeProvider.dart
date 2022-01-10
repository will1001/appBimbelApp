import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  String _fontFamily = 'Nunito';
  Color _mainColor = Color(0xffBF1E2D);

  String get fontFamily => _fontFamily;
  Color get mainColor => _mainColor;
}
