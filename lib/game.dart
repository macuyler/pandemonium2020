import 'package:flutter/material.dart';
import 'blocks.dart';
import 'globals.dart';

class GamePainter extends CustomPainter {
  List<Block> blocks;
  int score;
  GamePainter({ this.blocks, this.score });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue
      ..isAntiAlias = true;
    drawScore(canvas, size);
    drawBottom(canvas, size, paint);
    drawHouses(canvas, size, paint);
    paint.color = Colors.blue;
    blocks.forEach((block) {
      paint.color = block.color;
      canvas.drawRect(Rect.fromLTWH(block.x, block.y + size.height * (1/3), blockWidth, blockHeight), paint);
    });
  }

  void drawScore(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Score: ${this.score}',
        style: TextStyle(
          color: Colors.black,
          fontSize: 30,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout(
      minWidth: size.width,
      maxWidth: size.width,
    );
    final offset = Offset(0, (size.height / 6) - 15);
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