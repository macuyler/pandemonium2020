import 'package:flutter/material.dart';
import 'dart:math';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _newBlock();
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
      if (tX >= block.x && tX <= block.x + blockWidth && tY >= block.y && tY <= block.y + blockHeight) {
        setState(() {
          _blockToDrag = i;
        });
      }
    });
  }

  void _handlePanEnd(details) {
    final size = MediaQuery.of(context).size;
    bool scored = false;
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
          double y = (i * (size.height * (2/3)) / houses) + 20;
          if (block.y + blockHeight >= y && block.y <= y + houseHeight) {
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
        _score += scored ? 1 : -1;
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
      if (b.y < 0 || b.y > size.height * (8/15) - blockHeight + 20 + houseHeight) {
        b.updatePos(dx: 0, dy: -details.delta.dy);
      }
      setState(() {
        _blocks[_blockToDrag] = b;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanStart: _handlePanStart,
        onPanEnd: _handlePanEnd,
        onPanUpdate: _handlePanUpdate,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: CustomPaint(
            painter: GamePainter(blocks: _blocks, score: _score),
          ),
        ),
      ),
    );
  }
}
