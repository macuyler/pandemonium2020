/*
 * This is a list of database migrations that need to be run to keep databases
 * up to date with the current schemas.
 */

import './names.dart';

final List<String> migrations = [
  '!', // Version 1 --> 2
  '!', // Version 2 --> 3
  '!', // Version 3 --> 4
  """
  ALTER TABLE $tableLevels ADD COLUMN $columnLeaderboardId TEXT DEFAULT '';
  """, // Version 4 --> 5
  """
  CREATE TABLE $tableSettings (
    $columnDisplayName TEXT NOT NULL,
    $columnUseFullScreen INTEGER NOT NULL DEFAULT 1 CHECK($columnUseFullScreen IN (0,1))
  );
  """, // Version 5 --> 6
];
