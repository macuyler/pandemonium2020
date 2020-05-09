import 'package:flutter/material.dart';
import './gamescreen.dart';
import '../schemas/levels.dart';
import '../globals.dart';
import '../db.dart';

class LevelScreen extends StatefulWidget {
  LevelScreen({Key key}) : super(key: key);

  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  DatabaseHelper _db = DatabaseHelper.instance;
  List<Level> _levels = [];
  int _levelIndex = -1;

  @override
  void initState() {
    super.initState();
    _syncLevelsDB();
  }

  void _syncLevelsDB() async {
    List<Level> levels = await _db.getLevels();
    // TODO: replace staticLevels with a cloud database allowing for hot level updates
    if (!equalLevels(levels, staticLevels)) {
      await _db.clearLevels();
      staticLevels.forEach((l) async {
        await _db.insertLevel(l);
      });
      levels = await _db.getLevels();
    }
    setState(() {
      _levels = levels;
    });
  }

  Widget _getLevel() {
    if (_levelIndex >= 0) {
      Level level = _levels[_levelIndex];
      return GameScreen(
        level: level,
        onClose: () {
          setState(() {
            _levelIndex = -1;
          });
        }
      );
    }
    return null;
  }

  List<Widget> _getButtons(BuildContext context) {
    List<Widget> buttons = [];
    _levels.asMap().forEach((i, level) {
      buttons.add(OutlineButton(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          height: 40,
          child: Center(
            child: Text(level.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20
              ),
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            _levelIndex = i;
          });
        },
      ));
    });
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return _levelIndex >= 0 ? _getLevel() : Scaffold(
      appBar: AppBar(
        title: Text('Level Select'),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        children: _getButtons(context)
      ),
    );
  }
}