import 'package:firebase_auth/firebase_auth.dart';
import 'package:fisikamu/Provider/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'APIAction.dart';
import 'Widgets/AlertDialogBox.dart';
// import 'package:fisikamu/Widgets/a';

final GoogleSignIn googleSignIn = GoogleSignIn();
DateTime? currentBackPressTime;

nullStringReplacer(String? data) {
  return data == null ? "" : data;
}

logOut(BuildContext context) async {
  await googleSignIn.signOut();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  // userProvider.userData.clear();
  Navigator.pushNamed(context, '/login');
}

checkLoginCache(BuildContext context) {
  Future.delayed(const Duration(milliseconds: 2000), () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idCache = prefs.getString('id');
    String? emailCache = prefs.getString('email');
    String? usernameCache = prefs.getString('username');
    String? photoCache = prefs.getString('photo');
    String? idKelasCache = prefs.getString('id_kelas');

    Map<String, String> dataCache = {
      "id": idCache.toString(),
      "email": emailCache.toString(),
      "username": usernameCache.toString(),
      "photo": photoCache.toString(),
      "id_kelas": idKelasCache.toString(),
    };

    if (emailCache == null) {
      Navigator.pushNamed(context, '/login');
    } else {
      saveProvider(dataCache, context);
      Navigator.pushNamed(context, '/home', arguments: {});
    }
  });
}

saveCache(Map<String, String> data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');

  if (email == "" || email == null) {
    await prefs.setString('id', data["id"].toString());
    await prefs.setString('email', data["email"].toString());
    await prefs.setString('username', data["username"].toString());
    await prefs.setString('photo', data["photo"].toString());
    await prefs.setString('id_kelas', data["id_kelas"].toString());
  }
}

saveProvider(Map<String, String> data, BuildContext context) async {
  var userProvider = Provider.of<UserProvider>(context, listen: false);

  userProvider.changeid(data['id'].toString());
  userProvider.changeemail(data['email'].toString());
  userProvider.changeusername(data['username'].toString());
  userProvider.changephoto(data['photo'].toString());
}

Future loginWithGoogle(BuildContext context) async {
  GoogleSignInAccount? _user;

  final googleUser = await googleSignIn.signIn();
  if (googleUser == null) return;
  _user = googleUser;
  final googleAuth = await googleUser.authentication;
  final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
  await FirebaseAuth.instance.signInWithCredential(credential);

  // print("_user");
  // print(_user);

  getAPIbyParam('/users_details', '?email=${_user.email}').then((res) async {
    if (res.length == 0) {
      await googleSignIn.signOut();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialogBox("alert", "email belum terdaftar", []);
          });
    } else {
      // print("res[0].id");
      // print(res);
      Map<String, String> data = {
        "id": res[0]['id'],
        "username": res[0]['username'],
        "email": res[0]['email'],
        "password": res[0]['password'],
        "photo": res[0]['photo'],
        "id_kelas": res[0]['id_kelas'],
      };

      saveCache(data);
      saveProvider(data, context);
      Navigator.pushNamed(context, '/home', arguments: data);
    }
  });
}

Future loginManual(BuildContext context, String _email, _password) async {
  getAPIbyParam('/users_details', '?email=$_email').then((res) async {
    if (res.length == 0) {
      await googleSignIn.signOut();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialogBox("alert", "email belum terdaftar", []);
          });
    } else {
      if (_password == res[0]['password']) {
        Map<String, String> data = {
          "id": res[0]['id'],
          "email": res[0]['email'],
          "username": res[0]['username'],
          "photo": res[0]['photo'],
          "id_kelas": res[0]['id_kelas'],
        };

        saveCache(data);
        saveProvider(data, context);
        Navigator.pushNamed(context, '/home', arguments: data);
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialogBox("alert", "Password Salah", []);
            });
      }
    }
  });
}

Future registerWithGoogle(BuildContext context) async {
  String uuid = Uuid().v1();
  GoogleSignInAccount? _user;

  final googleUser = await googleSignIn.signIn();
  if (googleUser == null) return;
  _user = googleUser;
  final googleAuth = await googleUser.authentication;
  final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
  await FirebaseAuth.instance.signInWithCredential(credential);

  // print("_user");
  // print(_user);

  Map<String, String> dataUsers = {
    "id": uuid,
    "username": _user.displayName.toString(),
    "email": _user.email,
    "password": _user.hashCode.toString(),
    "role": "",
    "token_chat": "",
  };

  Map<String, String> dataMentor = {
    'id_user': uuid,
    'photo': _user.photoUrl.toString()
  };

  getAPIbyParam('/users_details', '?email=${_user.email}').then((res) async {
    if (res.length == 0) {
      postAPI("/users_api", dataUsers);
      postAPI("/users_details", dataMentor);
      Map<String, String> data = {
        "id": uuid,
        "username": _user!.displayName.toString(),
        "email": _user.email,
        "password": _user.hashCode.toString(),
        "photo": _user.photoUrl.toString(),
        "id_kelas": "",
      };
      saveCache(data);
      saveProvider(data, context);
    } else {
      putAPI("/users_api", dataUsers);
      Map<String, String> data = {
        "id": res[0]['id'],
        "username": res[0]['username'],
        "email": res[0]['email'],
        "password": res[0]['password'],
        "photo": res[0]['photo'],
        "id_kelas": res[0]['id_kelas'],
      };
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      saveCache(data);
      saveProvider(data, context);
    }

    Navigator.pushNamed(context, '/home', arguments: dataUsers);
  });
}

Future registerManual(BuildContext context, String _username, _email, _password,
    _confirmPassword) async {
  if (_password != _confirmPassword) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialogBox(
              "alert", "Password yang di ketik tidak sama", []);
        });
  } else {
    String uuid = Uuid().v1();

    Map<String, String> dataUsers = {
      "id": uuid,
      "username": _username,
      "email": _email,
      "password": _password,
      "role": "",
      "token_chat": "",
    };

    Map<String, String> dataMentor = {'id_user': uuid, 'photo': ""};

    getAPIbyParam('/users_details', '?email=$_email').then((res) async {
      if (res.length == 0) {
        postAPI("/users_api", dataUsers);
        postAPI("/users_details", dataMentor);
        Map<String, String> data = {
          "id": uuid,
          "username": _username,
          "email": _email,
          "password": _password,
          "photo": "",
          "id_kelas": "",
        };

        saveCache(data);
        saveProvider(data, context);
        Navigator.pushNamed(context, '/home', arguments: data);
      } else {
        putAPI("/users_api", dataUsers);
        Map<String, String> data = {
          "id": res[0]['id'],
          "username": res[0]['username'],
          "email": res[0]['email'],
          "password": res[0]['password'],
          "photo": res[0]['photo'],
          "id_kelas": res[0]['id_kelas'],
        };

        saveCache(data);
        saveProvider(data, context);
        Navigator.pushNamed(context, '/home', arguments: data);
      }
    });
  }
}

// Future<bool> onWillPop(BuildContext context) {
//   DateTime now = DateTime.now();
//   if (currentBackPressTime == null ||
//       now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
//     currentBackPressTime = now;
//     // Fluttertoast.showToast(msg: exit_warning);
//     return Future.value(false);
//   }
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialogBox("", "Keluar dari App?", [
//           AlertButton("Ya", Colors.blue, Container(), () async {
//             SystemNavigator.pop();
//           }, context),
//           AlertButton("tidak", Colors.blue, Container(), () {
//             Navigator.pop(context);
//           }, context),
//         ]);
//       });
//   return Future.value(true);
//   // return shouldPop ?? false;
// }

// responsive(BuildContext context, String _layar, var outpout) {
//   double _width = MediaQuery.of(context).size.width;
//   double _height = MediaQuery.of(context).size.height;
//   switch (_layar) {
//     case "layar1":
//       if (_width <= 360 && _height <= 640) {
//         return outpout;
//       }
//       break;
//     case "layar2":
//       if (_width >= 360 && _width <= 480 && _height >= 640 && _height <= 640) {
//         return outpout;
//       }
//       break;
//     default:
//   }
// }

screenDetect(context) {
  double _width = MediaQuery.of(context).size.width;
  double _height = MediaQuery.of(context).size.height;
  // print(_width);
  // print(_height);
  if (_width <= 360 && _height <= 672) {
    return "Screen 1";
  } else if (_width >= 360 &&
      _width <= 480 &&
      _height >= 672 &&
      _height <= 854) {
    return "Screen 2";
  } else {
    return "Screen 1";
  }
}
