import 'package:flutter/material.dart';

class Block {
  double x;
  double y;
  Color color;
  bool infected;
  Block({this.x, this.y, this.color, this.infected});

  void updatePos({dx: double, dy: double}) {
    this.x += dx;
    this.y += dy;
  }

  void setInfected(bool inf) {
    this.infected = inf;
  }
}