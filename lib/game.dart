import 'package:flutter/material.dart';
import 'blocks.dart';
import 'globals.dart';

class GamePainter extends CustomPainter {
  List<Block> blocks;
  int score;
  String time;
  GamePainter({ this.blocks, this.score, this.time });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue
      ..isAntiAlias = true;
    drawScore(canvas, size);
    drawTime(canvas, size);
    if (time == '00:00') {
      drawHelper(canvas, size);
    }
    drawBottom(canvas, size, paint);
    drawHouses(canvas, size, paint);
    paint.color = Colors.blue;
    blocks.forEach((block) {
      paint.color = block.color;
      canvas.drawRect(Rect.fromLTWH(block.x, block.y + size.height * (1/3), blockWidth, blockHeight), paint);
    });
  }

  TextPainter drawText({Size size, String text, TextStyle textStyle}) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout(
      minWidth: size.width,
      maxWidth: size.width,
    );
    return textPainter;
  }

  void drawScore(Canvas canvas, Size size) {
    final textPainter = drawText(
      size: size,
      text: 'Score: ${this.score}',
      textStyle: TextStyle(
        color: Colors.black,
        fontSize: 30,
      )
    );
    final offset = Offset(0, (size.height / 6) - 15);
    textPainter.paint(canvas, offset);
  }

  void drawTime(Canvas canvas, Size size) {
    final textPainter = drawText(
      size: size,
      text: 'Time: ${this.time}',
      textStyle: TextStyle(
        fontSize: 25,
        color: Colors.black
      )
    );
    final offset = Offset(0, (size.height / 6) + 30);
    textPainter.paint(canvas, offset);
  }

  void drawHelper(Canvas canvas, Size size) {
    final textPainter = drawText(
      size: size,
      text: 'Double tap to start!',
      textStyle: TextStyle(
        fontSize: 20,
        color: Colors.grey[500]
      )
    );
    final offset = Offset(0, (size.height / 6) + 70);
    textPainter.paint(canvas, offset);
  }

  void drawBottom(Canvas canvas, Size size, Paint paint) {
    paint.color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(0, size.height * (1/3), size.width, size.height * (2/3)), paint);
  }

  void drawHouses(Canvas canvas, Size size, Paint paint) {
    int houses = leftColors.length;
    double yFactor = (size.height * (2/3)) / houses;
    // Draw Sides
    for (var i = 0; i < houses; i++) {
      double y = (yFactor * i) + (yFactor / 2) + (size.height * (1/3)) - (houseHeight / 2);
      Rect rl = Rect.fromLTWH(0, y, houseWidth, houseHeight);
      Rect rr = Rect.fromLTWH(size.width - houseWidth, y, houseWidth, houseHeight);
      paint.color = leftColors[i];
      canvas.drawRect(rl, paint);
      paint.color = rightColors[i];
      canvas.drawRect(rr, paint);
    }
  }

  @override
    bool shouldRepaint(GamePainter oldDelegate) => true;
}