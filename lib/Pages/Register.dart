import 'package:fisikamu/FunctionGroup.dart';
import 'package:fisikamu/Widgets/InputText.dart';
import 'package:fisikamu/Widgets/Label.dart';
import 'package:fisikamu/Widgets/PrimaryButton.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  TextEditingController confirmPasswordTextEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: formKey,
              child: ListView(
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: 180,
                    height: 100,
                  ),
                  InputText(
                      "Username", false, 65,1, userNameTextEditingController,
                      (val) {
                    return val.isEmpty || val.length < 2
                        ? "Username tidak boleh kosong"
                        : null;
                  },8),
                  InputText("Email", false, 65,1, emailTextEditingController,
                      (val) {
                    return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val)
                        ? null
                        : val.length == 0
                            ? 'Email Tidak Boleh Kosong'
                            : "Format email tidak benar";
                  },8),
                  InputText("Password", true, 65,1, passwordTextEditingController,
                      (val) {
                    return val.length < 6
                        ? "Isi Password minimal 6 karakter"
                        : null;
                  },8),
                  InputText("Confirm Password", true, 65,1,
                      confirmPasswordTextEditingController, (val) {
                    return val.length < 6
                        ? "Isi Password minimal 6 karakter"
                        : null;
                  },8),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8),
                    child: PrimaryButton(
                        "Daftar", Color(0xFF1A91DA), Container(), () {
                      if (formKey.currentState!.validate()) {
                        registerManual(
                            context,
                            userNameTextEditingController.text,
                            emailTextEditingController.text,
                            passwordTextEditingController.text,
                            confirmPasswordTextEditingController.text);
                      }
                    }, context),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8),
                    child: PrimaryButton(
                        "Daftar Dengan google",
                        Colors.redAccent,
                        Image.asset(
                          "assets/images/googleLogo.png",
                          width: 40,
                          height: 40,
                        ), () {
                      // signInWithGoogle();
                      registerWithGoogle(context);
                    }, context),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: GestureDetector(
                      child: Label("Sudah Punya akun ? , Login di sini",
                          MainAxisAlignment.center),
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                  ),
                ],
              )),
    );
  }
}
