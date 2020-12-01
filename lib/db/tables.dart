/*
 * This file contains the current definition of the database schema.
 */

import './names.dart';

final List<String> tables = [
  '''
  CREATE TABLE $tableLevels (
    $columnId INTEGER PRIMARY KEY,
    $columnLevelId TEXT NOT NULL,
    $columnName TEXT NOT NULL,
    $columnGameDur INTEGER NOT NULL,
    $columnNumPat INTEGER NOT NULL,
    $columnInfecRate INTEGER NOT NULL,
    $columnHouses INTEGER NOT NULL,
    $columnHealTime INTEGER NOT NULL,
    $columnOrder INTEGER NOT NULL,
    $columnLeaderboardId TEXT NOT NULL
  )
  ''', // Levels Table
  '''
  CREATE TABLE $tableScores (
    $columnId INTEGER PRIMARY KEY,
    $columnScore INTEGER NOT NULL,
    $columnLevelId TEXT NOT NULL,
    FOREIGN KEY($columnLevelId) REFERENCES $tableLevels($columnLevelId)
  )
  ''', // Scores Table
  '''
  CREATE TABLE $tableSettings (
    $columnDisplayName TEXT NOT NULL,
    $columnUseFullScreen INTEGER NOT NULL DEFAULT 1 CHECK($columnUseFullScreen IN (0,1))
  )
  ''', // Settings Table
];
