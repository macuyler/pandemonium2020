import 'package:flutter/material.dart';
import './gamescreen.dart';
import './levels.dart';
import './globals.dart';

class LevelScreen extends StatefulWidget {
  LevelScreen({Key key}) : super(key: key);

  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  int _levelIndex = -1;

  Widget _getLevel() {
    if (_levelIndex >= 0) {
      Level level = levels[_levelIndex];
      return GameScreen(level: level);
    }
    return null;
  }

  List<Widget> _getButtons() {
    List<Widget> buttons = [];
    levels.asMap().forEach((i, level) {
      buttons.add(OutlineButton(
        child: SizedBox(
          width: 100,
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
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _getButtons()
          ),
        )
      ),
    );
  }
}