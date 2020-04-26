import 'package:flutter/material.dart';
import './levels.dart';

const List<Color> leftColors = [Color.fromRGBO(255, 0, 0, 1), Colors.orange, Colors.yellow, Color.fromRGBO(22, 102, 10, 1), Colors.lightBlueAccent];
const List<Color> rightColors = [Color.fromRGBO(5, 56, 159, 1), Color.fromRGBO(147, 44, 160, 1), Color.fromRGBO(243, 177, 234, 1), Color.fromRGBO(134, 255, 217, 1), Color.fromRGBO(134, 134, 134, 1)];

const double blockWidth = 45;
const double blockHeight = 45;
const double houseWidth = 60;
const double houseHeight = 60;

List<Level> levels = [
  new Level(
    name: 'Level 1',
    gameDuration: 60,
    numPatients: 3,
    infectionRate: 20,
    houses: 1,
    healTime: 3
  ),
  new Level(
    name: 'Level 2',
    gameDuration: 60,
    numPatients: 5,
    infectionRate: 10,
    houses: 1,
    healTime: 5
  ),
  new Level(
    name: 'Hard One',
    gameDuration: 60,
    numPatients: 5,
    infectionRate: 5,
    houses: 5,
    healTime: 5
  ),
];
