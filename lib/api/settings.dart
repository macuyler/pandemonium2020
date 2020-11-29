import 'package:sqflite/sqflite.dart';
import '../db/helper.dart';
import '../db/names.dart';
import '../schemas/settings.dart';

class SettingsApi {
  final DatabaseHelper _dh = DatabaseHelper.instance;

  // Core Api
  Future<Settings> getSettings() async {
    Database db = await _dh.database;
    List<Map> qry = await db.query(tableSettings, limit: 1);
    if (qry.isNotEmpty) return new Settings.fromMap(qry[0]);
    return new Settings(displayName: '', useFullScreen: true);
  }

  Future<int> setSettings(Settings settings) async {
    Database db = await _dh.database;
    await db.delete(tableSettings); // Clear old settings.
    return await db.insert(tableSettings, settings.toMap());
  }

  // Helper Methods
  Future<String> getDisplayName() async {
    Settings settings = await getSettings();
    return settings.displayName;
  }

  Future<int> setDisplayName(String name) async {
    Settings settings = await getSettings();
    settings.displayName = name;
    return setSettings(settings);
  }

  Future<bool> getUseFullScreen() async {
    Settings settings = await getSettings();
    return settings.useFullScreen;
  }

  Future<int> setUseFullScreen(bool ufs) async {
    Settings settings = await getSettings();
    settings.useFullScreen = ufs;
    return setSettings(settings);
  }
}
