import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitWave(
            color: Colors.blue.shade400,
            size: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              "Tunggu Ya",
              style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 17,
                  color: Colors.blue.shade400,
                  fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }
}
