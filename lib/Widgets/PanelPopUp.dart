import 'package:fisikamu/Widgets/CustomText.dart';
import 'package:flutter/material.dart';

Widget panelPopUp(
    BuildContext context, String _text, List<Widget> _buttonList) {
  return Container(
    color: Colors.black26,
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    child: Center(
      child: Container(
        color: Colors.white,
        width: 312,
        height: 138,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: customText(
                  context, _text, TextAlign.center, 16, FontWeight.w400),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buttonList,
            )
          ],
        ),
      ),
    ),
  );
}
