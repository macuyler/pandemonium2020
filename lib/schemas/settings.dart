import '../db/names.dart';

class Settings {
  String displayName;
  bool useFullScreen;
  Settings({this.displayName, this.useFullScreen});

  Settings.fromMap(Map<String, dynamic> map) {
    this.displayName =
        map[columnDisplayName] is String ? map[columnDisplayName] : '';
    this.useFullScreen =
        map[columnUseFullScreen] is int ? map[columnUseFullScreen] == 1 : true;
  }

  Map<String, dynamic> toMap() {
    return {
      columnDisplayName: this.displayName,
      columnUseFullScreen: this.useFullScreen ? 1 : 0,
    };
  }
}
