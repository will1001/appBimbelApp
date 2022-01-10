import 'package:flutter/material.dart';

class GlobalProvider with ChangeNotifier {
  String _baseUrl = "https://fisikamu.xyz";

  String get baseUrl => _baseUrl;
}
