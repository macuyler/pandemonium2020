import 'package:flutter/material.dart';

Widget getStatusBar(Brightness brightness) => PreferredSize(
  preferredSize: Size.fromHeight(0),
  child: AppBar(
    backgroundColor: Color.fromRGBO(0, 0, 0, 0),
    brightness: brightness,
    elevation: 0,
  )
);
