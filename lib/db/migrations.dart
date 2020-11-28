/*
 * This is a list of database migrations that need to be run to keep databases
 * up to date with the current schemas.
 */

import './names.dart';

final List<String> migrations = [
  """
  ALTER TABLE $tableLevels ADD COLUMN $columnLeaderboardId TEXT DEFAULT '';
  """, // Version 4 --> 5
];
