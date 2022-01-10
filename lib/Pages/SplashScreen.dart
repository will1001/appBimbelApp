import 'package:fisikamu/FunctionGroup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginCache(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SvgPicture.asset(
        "assets/images/Logo2.svg",
        width: 50,
        height: 50,
        color: Colors.red,
      )),
    );
  }
}
