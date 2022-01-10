import 'package:fisikamu/FunctionGroup.dart';
import 'package:fisikamu/Widgets/ButtonStyle1.dart';
import 'package:fisikamu/Widgets/InputText.dart';
import 'package:fisikamu/Widgets/Label.dart';
import 'package:fisikamu/Widgets/PanelPopUp.dart';
import 'package:fisikamu/Widgets/PrimaryButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  bool _showPopUp = false;
  String? _popUpMessage;
  List<Widget> _widgetPopUpButton = [];

  // final GoogleSignIn googleSignIn = GoogleSignIn();
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      if (_showPopUp) {
       if(mounted){
          setState(() {
          _showPopUp = false;
        });
       }
      } else {
        currentBackPressTime = now;
      }
      // Fluttertoast.showToast(msg: exit_warning);
      return Future.value(false);
    }
    // print("Asfasf");
    if(mounted){
      setState(() {
      _showPopUp = true;
      _popUpMessage = "Keluar dari App?";
      _widgetPopUpButton = [
        buttonStyle1(context, 70, 'Ya', Color(0xFFF6F5FF),Colors.black, () {
          SystemNavigator.pop();
        }),
        buttonStyle1(context, 70, 'Tidak', Color(0xFFF6F5FF),Colors.black, () {
          if (mounted) {
            setState(() {
              _showPopUp = false;
            });
          }
        }),
      ];
    });
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => onWillPop(),
      child: Scaffold(
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Form(
                    key: formKey,
                    child: ListView(
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          width: 180,
                          height: 100,
                        ),
                        InputText(
                            "Email", false, 45, 1, emailTextEditingController,
                            (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)
                              ? null
                              : "Enter correct email";
                        }, 8),
                        InputText("Password", true, 45, 1,
                            passwordTextEditingController, (val) {
                          return val.isEmpty || val.length < 2
                              ? "isi password"
                              : null;
                        }, 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16),
                          child: PrimaryButton(
                              "Login", Color(0xFF1A91DA), Container(), () {
                            // signMeIN();
                            loginManual(
                                context,
                                emailTextEditingController.text,
                                passwordTextEditingController.text);
                          }, context),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Label(
                              "Atau Login Dengan", MainAxisAlignment.center),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16),
                          child: PrimaryButton(
                              "Masuk dengan google",
                              Colors.redAccent,
                              Image.asset(
                                "assets/images/googleLogo.png",
                                width: 40,
                                height: 40,
                              ), () async {
                            loginWithGoogle(context);
                          }, context),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: GestureDetector(
                            child: Label("Belum Punya akun ? , Daftar di sini",
                                MainAxisAlignment.center),
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  _showPopUp
                      ? panelPopUp(
                          context, _popUpMessage.toString(), _widgetPopUpButton)
                      : Container()
                ],
              ),
      ),
    );
  }
}
