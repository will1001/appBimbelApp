import 'package:fisikamu/Provider/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Widget menuIconBab(
    String _text, String _icon, var _onPressed, BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  return GestureDetector(
    onTap: _onPressed,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          _icon,
          width: 59,
          height: 59.66,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Container(
            width: 80,
            child: Text(_text,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                    fontSize: 14, fontWeight: FontWeight.w400)),
          ),
        ),
      ],
    ),
  );
}
