import 'package:flutter/material.dart';

class LevelScreen extends StatefulWidget {
  LevelScreen({Key key}) : super(key: key);

  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  int _levelIndex = -1;

  Widget _getLevel() {
    if (_levelIndex >= 0) {
      return Text('Hello Level');
    }
    return null;
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
            children: <Widget>[
              Text('Levels Go Here')
            ],
          ),
        )
      ),
    );
  }
}