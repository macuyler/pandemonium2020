import 'package:flutter/material.dart';
import './gamescreen.dart';
import '../schemas/levels.dart';
import '../ui/stars.dart';
import '../db.dart';
import '../firebase.dart';

class LevelScreen extends StatefulWidget {
  LevelScreen({Key key}) : super(key: key);

  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  DatabaseHelper _db = DatabaseHelper.instance;
  List<Level> _levels = [];
  List<int> _highScores = [];
  int _levelIndex = -1;

  @override
  void initState() {
    super.initState();
    _syncLevelsDB();
  }

  void _syncLevelsDB() async {
    List<Level> levels = await _db.getLevels();
    List<Level> cloudLevels = await getCloudLevels();
    if (!equalLevels(levels, cloudLevels)) {
      await _db.clearLevels();
      cloudLevels.forEach((l) async {
        await _db.insertLevel(l);
      });
      levels = await _db.getLevels();
    }
    setState(() {
      _levels = levels;
      _highScores = List<int>.generate(levels.length, (i) => 0);
    });
    _getHighScores();
  }

  void _getHighScores() async {
    List<int> highScores = [];
    for (int i = 0; i < _levels.length; i++) {
      Level level = _levels[i];
      List<int> scores = await _db.getLevelScores(level.id);
      scores.sort((a, b) => b - a);
      if (scores.length > 0) {
        highScores.add(scores[0]);
      } else {
        highScores.add(0);
      }
    }
    setState(() {
      _highScores = highScores;
    });
  }

  Widget _getLevel() {
    if (_levelIndex >= 0) {
      Level level = _levels[_levelIndex];
      return GameScreen(
        level: level,
        onClose: () {
          _getHighScores();
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(level.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20
                  ),
                ),
                Stars(score: _highScores[i], dur: level.gameDuration, size: 20),
              ],
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