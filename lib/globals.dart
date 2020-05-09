import 'package:flutter/material.dart';
import './schemas/levels.dart';

const List<Color> leftColors = [Color.fromRGBO(255, 0, 0, 1), Colors.orange, Colors.yellow, Color.fromRGBO(22, 102, 10, 1), Colors.lightBlueAccent];
const List<Color> rightColors = [Color.fromRGBO(5, 56, 159, 1), Color.fromRGBO(147, 44, 160, 1), Color.fromRGBO(243, 177, 234, 1), Color.fromRGBO(134, 255, 217, 1), Color.fromRGBO(134, 134, 134, 1)];

const double blockWidth = 45;
const double blockHeight = 45;
const double houseWidth = 60;
const double houseHeight = 60;

const int oneStar = 35;
const int twoStar = 45;
const int threeStar = 60;
const int secToStar = 60;

List<Level> staticLevels = [
  new Level(
    name: 'Getting Started',
    gameDuration: 60,
    numPatients: 3,
    infectionRate: 20,
    houses: 1,
    healTime: 3
  ),
  new Level(
    name: 'Take it up a notch',
    gameDuration: 60,
    numPatients: 5,
    infectionRate: 10,
    houses: 1,
    healTime: 5
  ),
  new Level(
    name: 'Speed round',
    gameDuration: 10,
    numPatients: 3,
    infectionRate: 100,
    houses: 2,
    healTime: 2
  ),
  new Level(
    name: 'The Hard One',
    gameDuration: 60,
    numPatients: 5,
    infectionRate: 5,
    houses: 5,
    healTime: 5
  ),
];
