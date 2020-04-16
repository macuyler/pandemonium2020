import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import './game.dart';
import './blocks.dart';
import './globals.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pandemonium 2020',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Block> _blocks = [];
  int _blockToDrag = -1;
  int _score = 0;
  DateTime _startTime;
  int _durationSeconds = 60;
  String _clockTime = '00:00';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _newBlock();
  }

  void _setClockTime(int seconds) {
    int min = (seconds / 60).floor();
    int sec = seconds % 60;
    String minStr = min >= 10 ? '$min' : '0$min';
    String secStr = sec >= 10 ? '$sec' : '0$sec';
    setState(() {
      _clockTime = '$minStr:$secStr';
    });
  }

  void _startTimer() {
    setState(() {
      _startTime = DateTime.now();
      _score = 0;
      _clockTime = '01:00';
    });
    _tick();
  }

  void _stopTimer() {
    setState(() {
      _startTime = null;
    });
  }

  void _tick() {
    if (_startTime != null) {
      Timer(Duration(seconds: 1), () {
        _tick();
        _updateClock(DateTime.now());
      });
    }
  }

  void _updateClock(DateTime now) {
    if (_startTime != null) {
      int diff = ((now.millisecondsSinceEpoch - _startTime.millisecondsSinceEpoch) / 1000).floor();
      _setClockTime(_durationSeconds - diff);
      if (diff >= _durationSeconds) {
        _stopTimer();
      }
    }
  }

  void _newBlock() {
    final size = MediaQuery.of(context).size;
    Random r = Random();
    List<List> sides = [leftColors, rightColors];
    _blocks.add(new Block(
      x: (size.width / 2) - (blockWidth / 2),
      y: (size.height * (1/3)) - (blockHeight / 2),
      color: sides[r.nextInt(2)][r.nextInt(leftColors.length)]
    ));
    setState(() {
      _blocks = _blocks;
    });
  }

  void _handlePanStart(details) {
    _blocks.asMap().forEach((i, block) {
      double tX = details.globalPosition.dx;
      double tY = details.globalPosition.dy - (MediaQuery.of(context).size.height * (1/3));
      int forgivness = 15;
      if (
        tX >= block.x - forgivness && tX <= block.x + blockWidth + forgivness &&
        tY >= block.y - forgivness && tY <= block.y + blockHeight + forgivness
      ) {
        setState(() {
          _blockToDrag = i;
        });
      }
    });
  }

  void _handlePanEnd(details) {
    final size = MediaQuery.of(context).size;
    bool scored = false;
    bool touched = false;
    if (_blockToDrag != -1) {
      Block block = _blocks[_blockToDrag];
      List<Color> colors = [];
      if (block.x >= 0 && block.x <= houseWidth) {
        colors = leftColors;
      } else if (block.x + blockWidth >= size.width - houseWidth && block.x + blockWidth <= size.width) {
        colors = rightColors;
      }
      if (colors.length > 0) {
        int houses = leftColors.length;
        for (var i = 0; i < houses; i++) {
          double yFactor = (size.height * (2/3)) / houses;
          double y = (i * yFactor) + (yFactor / 2) - (houseHeight / 2);
          if (block.y + blockHeight >= y && block.y <= y + houseHeight) {
            touched = true;
            if (block.color == colors[i]) {
              scored = true;
            }
            _blocks.removeAt(_blockToDrag);
            _newBlock();
            break;
          }
        }
      }
      setState(() {
        _blockToDrag = -1;
        if (touched) {
          _score += scored ? 1 : -1;
        }
      });
    }
  }

  void _handlePanUpdate(details) {
    final size = MediaQuery.of(context).size;
    if (_blockToDrag != -1) {
      Block oldB = _blocks[_blockToDrag];
      Block b = new Block(x: oldB.x, y: oldB.y, color: oldB.color);
      b.updatePos(dx: details.delta.dx, dy: details.delta.dy);
      if (b.x < 0 || b.x > size.width - blockWidth) {
        b.updatePos(dx: -details.delta.dx, dy: 0);
      }
      if (b.y < 0 || b.y > size.height * (8/15) - blockHeight + (houseHeight * (3/2))) {
        b.updatePos(dx: 0, dy: -details.delta.dy);
      }
      setState(() {
        _blocks[_blockToDrag] = b;
      });
    }
  }

  void _blank(_) {}

  @override
  Widget build(BuildContext context) {
    bool running = _startTime != null;
    return Scaffold(
      body: GestureDetector(
        onPanStart: running ? _handlePanStart : _blank,
        onPanEnd: running ? _handlePanEnd : _blank,
        onPanUpdate: running ? _handlePanUpdate : _blank,
        onDoubleTap:  !running ? _startTimer : _stopTimer,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: CustomPaint(
            painter: GamePainter(blocks: _blocks, score: _score, time: _clockTime),
          ),
        ),
      ),
    );
  }
}
