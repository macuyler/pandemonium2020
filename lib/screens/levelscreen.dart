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
  List<Level> _newLevels = [];
  List<int> _highScores = [];
  int _levelIndex = -1;
  Level _currentLevel;
  bool _showUpdate = false;

  get levelIndex => _levelIndex;
  set levelIndex(int i) {
    _levelIndex = i;
    if (i >= 0 && i < _levels.length) {
      _currentLevel = _levels[i];
    } else {
      _currentLevel = null;
    }
  }

  @override
  void initState() {
    super.initState();
    _syncLevelsDB();
  }

  void _syncLevelsDB() async {
    List<Level> levels = await _db.getLevels();
    _setLevels(levels);
    List<Level> cloudLevels = await getCloudLevels();
    if (!equalLevels(levels, cloudLevels)) {
      await _db.clearLevels();
      cloudLevels.forEach((l) async {
        await _db.insertLevel(l);
      });
      levels = await _db.getLevels();
      setState(() {
        _showUpdate = true;
        _newLevels = levels;
      });
    }
  }

  void _setLevels(List<Level> levels) {
    levels.sort((a, b) => a.order - b.order);
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
    return GameScreen(
      level: _currentLevel,
      onClose: () {
        _getHighScores();
        setState(() {
          levelIndex = -1;
        });
      },
      onNext: () {
        setState(() {
          levelIndex += 1;
        });
      },
    );
  }

  Widget _buildButton(BuildContext context, int i) {
    Level level = _levels[i];
    return OutlineButton(
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
          levelIndex = i;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _currentLevel != null ? _getLevel() : Scaffold(
      appBar: AppBar(
        title: Text('Level Select'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemBuilder: _buildButton,
        itemCount: _levels.length,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      ),
      floatingActionButton: _showUpdate ? FloatingActionButton.extended(
        label: Text('Load New Levels!'),
        onPressed: () {
          _showUpdate = false;
          _setLevels(_newLevels);
        },
      ) : null,
    );
  }
}