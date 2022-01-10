import 'package:fisikamu/Widgets/CustomText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  Map args = {};
  String _menu = "terbaru";
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
      // print(arguments['data']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (args['data'] == null ? [] : args['data'] as List).length == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.asset(
                  //   'assets/images/empty.png',
                  //   width: 128,
                  //   height: 128,
                  // ),
                  SvgPicture.asset(
                    'assets/images/empty.svg',
                    width: 128,
                    height: 128,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text("Kosong",
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff708AB1))),
                  )
                ],
              ),
            )
          : ListView(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: Color(0xffEE5454),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                          )),
                      Text(
                        "Notifikasi",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: "Nunito",
                            fontSize: 20),
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 100,
                  child: ListView(
                    children: (args['data'] == null ? [] : args['data'] as List)
                        .map((e) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/detailsNotif',
                              arguments: e);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                  context,
                                  e['description'].toString().length > 30
                                      ? e['description']
                                              .toString()
                                              .substring(0, 30) +
                                          ". . ."
                                      : e['description'].toString(),
                                  TextAlign.left,
                                  14,
                                  FontWeight.w400),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  "Baca selengkapnya >>",
                                  style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                color: Color(0xffBFBFBF),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }
}
