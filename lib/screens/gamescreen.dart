import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import '../game.dart';
import '../schemas/blocks.dart';
import '../schemas/levels.dart';
import '../ui/stars.dart';
import '../ui/buttons.dart';
import '../globals.dart';
import '../db.dart';

class GameScreen extends StatefulWidget {
  final Level level;
  final Function onClose;
  final Function onNext;
  GameScreen({Key key, this.level, this.onClose, this.onNext}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  DatabaseHelper _db = DatabaseHelper.instance;
  List<Block> _blocks = [];
  List<Block> _hospital = new List(3);
  int _blockToDrag = -1;
  int _score = 0;
  int _highScore = 0;
  Map<Color, int> _houseScores = {};
  DateTime _startTime;
  String _clockTime = '00:00';
  bool _showMenu = false;

  @override
  void initState() {
    super.initState();
    _getHighScore();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _cleanState() {
    setState(() {
      _db = DatabaseHelper.instance;
      _blocks = [];
      _hospital = new List(3);
      _blockToDrag = -1;
      _score = 0;
      _highScore = 0;
      _houseScores = {};
      _clockTime = '00:00';
      _showMenu = false;
    });
  }

  void _getHighScore() async {
    List<int> scores = await _db.getLevelScores(widget.level.id);
    scores.sort((a, b) => b - a);
    if (scores.length > 0) {
      setState(() {
        _highScore = scores[0];
      });
    }
  }

  void _saveScore() async {
    int s = _score;
    int hs = _highScore;
    if (s > hs) {
      await _db.clearLevelScores(widget.level.id);
      await _db.insertScore(s, widget.level.id);
    }
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
      for (int i = 0; i < widget.level.numPatients; i++) {
        _newBlock(canBeInfected: false);
      }
      _setClockTime(widget.level.gameDuration);
    });
    _tick();
  }

  void _stopTimer() {
    setState(() {
      _startTime = null;
      _showMenu = true;
      _houseScores = {};
      _blocks = [];
      _hospital = new List(3);
    });
    _saveScore();
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
      _setClockTime(widget.level.gameDuration - diff);
      if (diff >= widget.level.gameDuration) {
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
    if (_blocks.length < widget.level.numPatients) {
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
        color: sides[r.nextInt(2)][r.nextInt(widget.level.houses)],
        infected: canBeInfected ? Random().nextInt(widget.level.infectionRate) == 0 : false,
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
    int forgivness = 2;
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
        int houses = widget.level.houses;
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
    } else {
      _handlePanStart(details);
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
          block.checkHealth(widget.level.healTime);
        }
      });
    });
  }

  bool _didStar(int star) => _score >= star * (widget.level.gameDuration / secToStar);

  Widget _buildMenu(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * (2/3) + 2,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stars(score: _score, dur: widget.level.gameDuration, size: 80),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: Text(_didStar(oneStar) ? 'Level Complete!' : 'Game Over!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40
                )
              ),
            ),
            _didStar(oneStar) ? ActionButton(
              text: 'Next Level',
              icon: Icons.keyboard_arrow_right,
              onPressed: () {
                _cleanState();
                widget.onNext();
              },
              main: true,
            ) : Text(''),
            ActionButton(
              text: 'Play Again',
              icon: Icons.replay,
              main: !_didStar(oneStar),
              onPressed: () {
                _getHighScore();
                setState(() {
                  _showMenu = false;
                  _clockTime = '00:00';
                });
              },
            ),
            ActionButton(
              text: 'Select Level',
              icon: Icons.list,
              onPressed: () {
                _cleanState();
                widget.onClose();
              },
            ),
          ],
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool running = _startTime != null;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Color.fromRGBO(0, 0, 0, 0),
          brightness: Brightness.light,
          elevation: 0,
        )
      ),
      body: GestureDetector(
        onPanStart: running ? _handlePanStart : _blank,
        onPanEnd: running ? _handlePanEnd : _blank,
        onPanUpdate: running ? _handlePanUpdate : _blank,
        onDoubleTap:  !_showMenu && !running ? _startTimer : () {},
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: CustomPaint(
            painter: GamePainter(
              blocks: _blocks,
              hospital: _hospital,
              score: _score,
              highScore: _highScore,
              time: _clockTime,
              houses: widget.level.houses,
            ),
          ),
        ),
      ),
      floatingActionButton: Align(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 60, 0, 0),
          child: FlatButton.icon(
            onPressed: () {
              setState(() {
                _startTime = null;
              });
              widget.onClose();
            },
            label: Text("Back",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
            icon: Icon(Icons.arrow_back_ios,
              size: 18,
              color: Colors.black87,
            ), 
          ),
        ),
        alignment: Alignment.topLeft,
      ),
      bottomSheet: _showMenu ? BottomSheet(
        backgroundColor: Color.fromRGBO(25, 25, 25, 1),
        builder: _buildMenu,
        onClosing: () {
          setState(() {
            _showMenu = true;
          });
        },
      ) : null,
    );
  }
}
