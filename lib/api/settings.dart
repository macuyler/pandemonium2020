import 'package:pandemonium2020/db/helper.dart';

import 'package:sqflite/sqflite.dart';
import '../db/helper.dart';
import '../db/names.dart';

class SettingsApi {
  final DatabaseHelper _dh = DatabaseHelper.instance;

  Future<String> getDisplayName() async {
    Database db = await _dh.database;
    List<Map> qry =
        await db.query(tableSettings, columns: [columnDisplayName], limit: 1);
    if (qry.isNotEmpty) return qry[0][columnDisplayName];
    return '';
  }

  Future<int> setDisplayName(String name) async {
    Database db = await _dh.database;
    await db.delete(tableSettings, where: 'true'); // Clear old displayName.
    Map<String, dynamic> settings = {};
    settings[columnDisplayName] = name;
    int id = await db.insert(tableSettings, settings);
    return id;
  }
}
