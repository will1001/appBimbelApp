import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget appBarWithLogo(BuildContext context, String _username, var _showNotif,
    var _openProfil, String _photo, String _notif, bool _showIcon) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    color: Color(0xffEE5454),
    child: Padding(
      padding: const EdgeInsets.all(00.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: SvgPicture.asset(
              "assets/images/Logo2.svg",
              color: Colors.white,
              width: 100,
            ),
          ),
          _showIcon
              ? GestureDetector(
                  onTap: _showNotif,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                        Container(
                          // padding: EdgeInsets.all(1),
                          width: 10,
                          height: 10,
                          decoration: new BoxDecoration(
                            color: int.parse(_notif) == 0
                                ? Colors.transparent
                                : Colors.white,
                            shape: BoxShape.circle,
                          ),
                          // child: Center(
                          //   child: Text(
                          //     _notif,
                          //     textAlign: TextAlign.center,
                          //     style:
                          //         TextStyle(color: Colors.white, fontSize: 10),
                          //   ),
                          // ),
                        )
                      ],
                    ),
                  ),
                )
              : Container()
        ],
      ),
    ),
  );
}
