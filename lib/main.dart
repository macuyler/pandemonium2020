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
  final int gameDuration = 60; // seconds
  final int numPatients = 5; // number of
  final int infectionRate = 5; // 1 out of
  final int houses = 5; // number of
  final int healTime = 5; // seconds

  @override
  _MyHomePageState createState() => _MyHomePageState(
    dur: gameDuration,
    patients: numPatients,
    infRate: infectionRate,
    houses: houses,
    healTime: healTime,
  );
}

class _MyHomePageState extends State<MyHomePage> {
  int dur;
  int patients;
  int infRate;
  int houses;
  int healTime;
  _MyHomePageState({ this.dur, this.patients, this.infRate, this.houses, this.healTime });

  List<Block> _blocks = [];
  List<Block> _hospital = new List(3);
  int _blockToDrag = -1;
  int _score = 0;
  Map<Color, int> _houseScores = {};
  DateTime _startTime;
  String _clockTime = '00:00';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
      _houseScores = {};
      _blocks = [];
      _hospital = new List(3);
      for (int i = 0; i < this.patients; i++) {
        _newBlock(canBeInfected: false);
      }
      _setClockTime(this.dur);
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
      Timer(Duration(milliseconds: 10), () {
        _tick();
        _update();
        _updateClock(DateTime.now());
      });
    }
  }

  void _updateClock(DateTime now) {
    if (_startTime != null) {
      int diff = ((now.millisecondsSinceEpoch - _startTime.millisecondsSinceEpoch) / 1000).floor();
      _setClockTime(this.dur - diff);
      if (diff >= this.dur) {
        _stopTimer();
      }
    }
  }

  int _getTotalScore() {
    int total = 0;
    _houseScores.forEach((_, int i) {
      total += i;
    });
    return total;
  }

  void _newBlock({bool canBeInfected = true}) {
    if (_blocks.length < patients) {
      final size = MediaQuery.of(context).size;
      Random r = Random();
      List<List> sides = [leftColors, rightColors];
      double dx = Random().nextDouble();
      dx *= Random().nextBool() ? -1 : 1;
      double dy = Random().nextDouble();
      dy *= Random().nextBool() ? -1 : 1;
      _blocks.add(new Block(
        x: (Random().nextDouble() * (size.width - (houseWidth * 2) - 10 - blockWidth)) + houseWidth + 5,
        y: (Random().nextDouble() * (size.height * (2/3) - 40 - blockHeight - houseHeight)) + 20 + houseHeight,
        color: sides[r.nextInt(2)][r.nextInt(this.houses)],
        infected: canBeInfected ? Random().nextInt(this.infRate) == 0 : false,
        dx: dx,
        dy: dy,
      ));
      setState(() {
        _blocks = _blocks;
      });
    }
  }

  void _handlePanStart(details) {
    double tX = details.globalPosition.dx;
    double tY = details.globalPosition.dy - (MediaQuery.of(context).size.height * (1/3));
    int forgivness = 15;
    bool checkBlock(Block block) =>
      tX >= block.x - forgivness && tX <= block.x + blockWidth + forgivness &&
      tY >= block.y - forgivness && tY <= block.y + blockHeight + forgivness;
    _hospital.asMap().forEach((i, block) {
      if (block is Block && checkBlock(block)) {
        _hospital[i] = null;
        block.leaveHospit();
        _blocks.add(block);
      }
    });
    _blocks.asMap().forEach((i, block) {
      if (checkBlock(block)) {
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
    bool infected = false;
    Color house;
    if (_blockToDrag != -1) {
      Block block = _blocks[_blockToDrag];
      List<Color> colors = [];
      if (block.x >= 0 && block.x <= houseWidth) {
        colors = leftColors;
      } else if (block.x + blockWidth >= size.width - houseWidth && block.x + blockWidth <= size.width) {
        colors = rightColors;
      }
      if (colors.length > 0) {
        int houses = this.houses;
        for (var i = 0; i < houses; i++) {
          double yFactor = (size.height * (2/3)) / houses;
          double y = (i * yFactor) + (yFactor / 2) - (houseHeight / 2);
          if (block.y + blockHeight >= y && block.y <= y + houseHeight) {
            house = colors[i];
            touched = true;
            infected = block.infected;
            if (block.color == colors[i]) {
              scored = true;
            }
            _blocks.removeAt(_blockToDrag);
            _newBlock();
            break;
          }
        }
      } else {
        double hX = houseWidth + 20;
        double hY = 5;
        double hW = size.width - (houseWidth + 20) * 2;
        double hH = houseHeight;
        if (
          block.x + blockWidth >= hX && block.x <= hX + hW &&
          block.y + blockHeight >= hY && block.y <= hY + hH &&
          block.infected && _hospital.contains(null)
        ) {
          int hI = _hospital.indexWhere((a) => a == null);
          int beds = 3;
          double xFactor = (size.width - (houseWidth + 20) * 2) / beds;
          block.x = (xFactor * hI) + (xFactor / 2) + houseWidth + 20 - (blockWidth / 2);
          block.y = 5 + (houseHeight / 2) - (blockHeight / 2);
          block.hospitalize();
          _hospital[hI] = block;
          _blocks.removeAt(_blockToDrag);
          _newBlock();
        }
      }
      setState(() {
        _blockToDrag = -1;
        if (touched) {
          if (_houseScores.containsKey(house)) {
            if (infected && _houseScores[house] > 0) {
              _houseScores[house] = 0;
            } else {
              _houseScores[house] += infected || !scored ? -1 : 1;
            }
          } else {
            _houseScores[house] = infected || !scored ? -1 : 1;
          }
          _score = _getTotalScore();
        }
      });
    }
  }

  void _handlePanUpdate(details) {
    final size = MediaQuery.of(context).size;
    if (_blockToDrag != -1) {
      Block b = _blocks[_blockToDrag];
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

  void _update() {
    final size = MediaQuery.of(context).size;
    _blocks.asMap().forEach((i, block) {
      if (i != _blockToDrag) {
        int ickFactor = block.infected ? 2 : 1;
        block.updatePos(dx: block.dx / ickFactor, dy: block.dy / ickFactor);
        if (block.x < houseWidth + 5) {
          block.setDirection(dx: block.dx.abs(), dy: block.dy);
        } else if (block.x + blockWidth > size.width - houseWidth - 5) {
          block.setDirection(dx: block.dx.abs() * -1, dy: block.dy);
        }
        if (block.y < 10 + houseHeight) {
          block.setDirection(dx: block.dx, dy: block.dy.abs());
        } else if (block.y + blockHeight > size.height * (2/3) - 20) {
          block.setDirection(dx: block.dx, dy: block.dy.abs() * -1);
        }
         _blocks.asMap().forEach((j, other) {
          if (i != j && j != _blockToDrag && other.infected && blockCol(block, other)) {
            block.setInfected(true);
          }
          if (blockCol(block, other) && j != _blockToDrag) {
             if (block.y < other.y) {
              block.setDirection(dx: block.dx, dy: block.dy.abs() * -1);
             } else if (block.y > other.y) {
              block.setDirection(dx: block.dx, dy: block.dy.abs());
             }
             if (block.x < other.x) {
              block.setDirection(dx: block.dx.abs() * -1, dy: block.dy);
             } else if (block.x > other.x) {
              block.setDirection(dx: block.dx.abs(), dy: block.dy);
             }
          }
        });
      }
      _hospital.asMap().forEach((i, block) {
        if (block != null) {
          block.checkHealth(this.healTime);
        }
      });
    });
  }

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
            painter: GamePainter(
              blocks: _blocks,
              hospital: _hospital,
              score: _score,
              time: _clockTime,
              houses: this.houses,
            ),
          ),
        ),
      ),
    );
  }
}
