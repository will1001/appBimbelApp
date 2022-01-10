import 'package:fisikamu/Provider/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

Widget menuIcon(
    String _text,
    double _textSize,
    FontWeight _fontweight,
    String _icon,
    String _icongray,
    double _iconWidth,
    double _iconHeight,
    int _menuSelected,
    int _selectedIndex,
    var _onPressed,
    BuildContext context) {
  // print(_menuSelected);
  // print(_selectedIndex);
  // print(_icon);
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  return GestureDetector(
    onTap: _onPressed,
    child: Column(
      children: [
        SvgPicture.asset(
          '${_menuSelected == _selectedIndex ? _icon : _icongray}',
          width: _iconWidth,
          height: _iconHeight,
        ),
        Text(_text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: _textSize,
                fontFamily: themeProvider.fontFamily,
                fontWeight: _menuSelected == _selectedIndex
                    ? _fontweight
                    : FontWeight.w200))
      ],
    ),
  );
}
