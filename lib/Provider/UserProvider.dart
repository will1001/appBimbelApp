import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _id;
  String? _email;
  String? _username;
  String? _photo;
  late final Map<String, String> _userData;
  late final int _notif;

  String? get getid => _id;
  String? get getemail => _email;
  String? get getusername => _username;
  String? get getphoto => _photo;
  Map<String, String> get userData => _userData;
  int get notif => _notif;

  void changeid(String item) {
    _id = item;
    notifyListeners();
  }
  void changeemail(String item) {
    _email = item;
    notifyListeners();
  }
  void changeusername(String item) {
    _username = item;
    notifyListeners();
  }
  void changephoto(String item) {
    _photo = item;
    notifyListeners();
  }
 
  void addData(Map<String, String> item) {
    _userData = item;
    notifyListeners();
  }

  void updateNotif(int item) {
    _notif = item;
    notifyListeners();
  }

  void clearData() {
    _userData.clear();
    notifyListeners();
  }
}
