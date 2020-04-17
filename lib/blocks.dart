import 'package:flutter/material.dart';
import './globals.dart';

class Block {
  double x;
  double y;
  double dx;
  double dy;
  Color color;
  bool infected;
  Block({this.x, this.y, this.color, this.infected, this.dx, this.dy});

  void updatePos({dx: double, dy: double}) {
    this.x += dx;
    this.y += dy;
  }

  void setDirection({dx: double, dy: double}) {
    this.dx = dx;
    this.dy = dy;
  }

  void setInfected(bool inf) {
    this.infected = inf;
  }
}

bool blockCol(block, other) {
  bool collided = false;
  if (block.x + blockWidth > other.x && block.x < other.x + blockWidth) {
    if (block.y + blockHeight > other.y && block.y < other.y + blockHeight) {
      collided = true;
    }
  }
  return collided;
}