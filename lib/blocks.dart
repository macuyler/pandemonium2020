import 'package:flutter/material.dart';

class Block {
  double x;
  double y;
  Color color;
  Block({this.x, this.y, this.color});

  void updatePos({dx: double, dy: double}) {
    this.x += dx;
    this.y += dy;
  }
}