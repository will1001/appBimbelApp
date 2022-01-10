import 'package:fisikamu/APIAction.dart';
import 'package:fisikamu/Widgets/CustomText.dart';
import 'package:flutter/material.dart';

class DetailsNotifikasi extends StatefulWidget {
  const DetailsNotifikasi({Key? key}) : super(key: key);

  @override
  _DetailsNotifikasiState createState() => _DetailsNotifikasiState();
}

class _DetailsNotifikasiState extends State<DetailsNotifikasi> {
  Map args = {};

  changeReadStatusNotif(var _data) {
    Map<String, String> dataNotif = {
      'id': _data['id'].toString(),
      'id_users': _data['id_users'].toString(),
      'title': _data['title'].toString(),
      'description': _data['description'].toString(),
      'status': "read",
      'send_status': "sended"
    };
    // print(dataNotif);

    putAPI('/notification', dataNotif);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      var arguments = (ModalRoute.of(context)!.settings.arguments as Map);
      if (mounted) {
        if (mounted) {
          setState(() {
            args = arguments;
          });
        }
      }
      changeReadStatusNotif(arguments);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            customText(context, args['title'] == null ? "" : args['title'],
                TextAlign.left, 24, FontWeight.w700),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: customText(
                  context,
                  args['description'] == null ? "" : args['description'],
                  TextAlign.left,
                  17,
                  FontWeight.w400),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                customText(
                    context,
                    args['created_at'] == null ? "" : args['created_at'],
                    TextAlign.left,
                    14,
                    FontWeight.w300),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  customText(
                      context, 'Admin', TextAlign.left, 14, FontWeight.w400),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
