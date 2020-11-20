import 'package:flutter/material.dart';
import './gamescreen.dart';
import './tutorialscreen.dart';
import '../schemas/levels.dart';
import '../ui/stars.dart';
import '../db/index.dart';
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
  bool _showTutorial = false;

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
    return _showTutorial
        ? TutorialScreen(onClose: () {
            setState(() {
              _showTutorial = false;
            });
          })
        : GameScreen(
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
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: OutlineButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45),
        ),
        splashColor: Color.fromRGBO(255, 255, 255, 0.6),
        highlightColor: Color.fromRGBO(255, 255, 255, 0.6),
        borderSide: BorderSide(
          color: Color.fromRGBO(255, 255, 255, 0.8),
          width: 1.0,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          height: 45,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  level.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                Stars(score: _highScores[i], dur: level.gameDuration, size: 20),
              ],
            ),
          ),
        ),
        onPressed: () {
          bool showTutorial = true;
          _highScores.forEach((hs) {
            if (hs > 0) {
              showTutorial = false;
            }
          });
          setState(() {
            _showTutorial = showTutorial;
            levelIndex = i;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _currentLevel != null
        ? _getLevel()
        : Scaffold(
            backgroundColor: Color.fromRGBO(25, 25, 25, 1),
            appBar: AppBar(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10))),
              title: Text('Level Select'),
              centerTitle: true,
              brightness: Brightness.dark,
            ),
            body: ListView.builder(
              itemBuilder: _buildButton,
              itemCount: _levels.length,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            ),
            floatingActionButton: _showUpdate
                ? FloatingActionButton.extended(
                    label: Text('Load New Levels!'),
                    onPressed: () {
                      _showUpdate = false;
                      _setLevels(_newLevels);
                    },
                  )
                : null,
          );
  }
}
