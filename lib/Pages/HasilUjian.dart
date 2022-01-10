import 'package:fisikamu/Widgets/ButtonStyle1.dart';
import 'package:fisikamu/Widgets/CustomText.dart';
import 'package:flutter/material.dart';

class HasilUjian extends StatefulWidget {
  const HasilUjian({Key? key}) : super(key: key);

  @override
  _HasilUjianState createState() => _HasilUjianState();
}

class _HasilUjianState extends State<HasilUjian> {
  Map args = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      var arguments = (ModalRoute.of(context)!.settings.arguments as Map);

      if (mounted) {
        setState(() {
          args = arguments;
        });
      }
    });
  }

  Future<bool> onWillPop() {
    Navigator.pop(context);
    Navigator.pop(context);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    // print(args['nilai'] == 100.toString());
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customText(
                    context, 'Skor ', TextAlign.center, 30, FontWeight.w800),
                customText(context, '', TextAlign.center, 30, FontWeight.w800),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 30),
              child: Container(
                width: 225,
                height: 125,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(33),
                    border: Border.all(
                      width: 2,
                      color: Color(0xffBF1E2D),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customText(context, '${args['nilai']}', TextAlign.center,
                        50, FontWeight.w700),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: customText(context, ' / 100', TextAlign.center, 20,
                          FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            args['nilai'] == 100.toString()
                ? customText(context, 'Selamat skormu sempurna',
                    TextAlign.center, 16, FontWeight.w400)
                : Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'kamu masih salah ',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Nunito'),
                        children: <TextSpan>[
                          TextSpan(
                              text: '${args['soal_salah']} soal ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: 'nih, yuk cek jawaban yang benar. '),
                        ],
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: buttonStyle1(context, 130, 'Pembahasan',
                        Color(0xffEE5454), Colors.white, () {
                      Navigator.pushNamed(context, '/showSoal', arguments: {
                        'data': args['data'],
                        'mode': 'Pembahasan',
                        'jawaban': args['jawaban']
                      });
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: buttonStyle1(
                        context, 130, 'Kembali', Colors.white, Colors.black,
                        () {
                      // Navigator.pushNamed(context, '/home');
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
