import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget AlertDialogBox(String _title, String _content, List<Widget> _action) {
  return AlertDialog(
    title: _title == ""
        ? Opacity(opacity: 0)
        : Text(
            _title,
          ),
    content: Text(
      _content,
      style: TextStyle(fontSize: 14),
    ),
    actions: _action,
  );
}
