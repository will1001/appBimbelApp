import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget PrimaryButton(String _text,Color _color,Widget _leadingIcon,var _onpressed,BuildContext _context) {
  return ButtonTheme(
    minWidth: MediaQuery.of(_context).size.width,
    height: 43.0,
    child: ElevatedButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right:10.0),
            child: _leadingIcon,
          ),
          Text(_text,style: TextStyle(color: Colors.white),),
        ],
      ),
      onPressed: _onpressed,
      style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(_color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.0),
                    side: BorderSide(color: _color)))),
      ),
  );
}
