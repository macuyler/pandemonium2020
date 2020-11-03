import 'package:flutter/material.dart';
import 'dart:ui' as UI;
import 'dart:math' as math;
import './schemas/blocks.dart';
import './globals.dart';

class GamePainter extends CustomPainter {
  List<Block> blocks;
  List<Block> hospital;
  int score;
  int highScore;
  String time;
  int houses;
  bool showHelper;
  UI.Image background;
  EdgeInsets padding;
  GamePainter(
      {this.blocks,
      this.hospital,
      this.score,
      this.highScore,
      this.time,
      this.houses,
      this.showHelper,
      this.background,
      this.padding});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue
      ..isAntiAlias = true;
    drawBackground(canvas, size, paint);
    drawScore(canvas, size);
    drawHighScore(canvas, size);
    drawTime(canvas, size);
    if (this.showHelper) {
      drawHelper(canvas, size);
    }
    drawBottom(canvas, size, paint);
    drawHouses(canvas, size, paint);
    drawHostpital(canvas, size, paint);
    paint.color = Colors.blue;
    blocks.forEach((block) {
      drawBlock(canvas, size, paint, block);
    });
  }

  TextPainter drawText(
      {Size size,
      String text,
      TextStyle textStyle,
      TextAlign textAlign = TextAlign.center}) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
      textAlign: textAlign,
    );
    textPainter.layout(
      minWidth: size.width,
      maxWidth: size.width,
    );
    return textPainter;
  }

  void drawBackground(Canvas canvas, Size size, Paint paint) {
    Rect dst = Rect.fromLTWH(0, -this.padding.top, size.width,
        size.height * (1 / 3) + 1 + this.padding.top);
    paint.color = Color.fromRGBO(25, 25, 25, 1);
    canvas.drawRect(dst, paint);
    if (this.background != null) {
      Rect src = Rect.fromLTWH(0, 0, 1280, 720);
      canvas.drawImageRect(this.background, src, dst, paint);
    }
  }

  void drawScore(Canvas canvas, Size size) {
    final textPainter = drawText(
        size: size,
        text: 'Score: ${this.score}',
        textStyle: TextStyle(
            color: Color.fromRGBO(254, 209, 40, 1),
            fontSize: 30,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                  blurRadius: 1.0,
                  color: Color.fromRGBO(250, 28, 22, 1),
                  offset: Offset(1.6, 1.6))
            ]));
    final offset = Offset(0, (size.height / 6) - 15);
    textPainter.paint(canvas, offset);
  }

  void drawHighScore(Canvas canvas, Size size) {
    final textPainter = drawText(
        size: size,
        text: 'High Score: ${this.highScore}',
        textStyle: TextStyle(color: Colors.white70, fontSize: 20),
        textAlign: TextAlign.start);
    final offset = Offset(size.width - 30 - 130, 17);
    textPainter.paint(canvas, offset);
  }

  void drawTime(Canvas canvas, Size size) {
    final textPainter = drawText(
        size: size,
        text: 'Time: ${this.time}',
        textStyle: TextStyle(
            fontSize: 25,
            color: Color.fromRGBO(254, 209, 40, 1),
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                  blurRadius: 1.0,
                  color: Color.fromRGBO(250, 28, 22, 1),
                  offset: Offset(1.5, 1.5))
            ]));
    final offset = Offset(0, (size.height / 6) + 30);
    textPainter.paint(canvas, offset);
  }

  void drawHelper(Canvas canvas, Size size) {
    final textPainter = drawText(
        size: size,
        text: 'Double tap to start!',
        textStyle: TextStyle(fontSize: 20, color: Colors.white70));
    final offset = Offset(0, (size.height * 1 / 3) - 30);
    textPainter.paint(canvas, offset);
  }

  void drawBottom(Canvas canvas, Size size, Paint paint) {
    paint.color = Color.fromRGBO(25, 25, 25, 1);
    canvas.drawRect(
        Rect.fromLTWH(0, size.height * (1 / 3), size.width,
            size.height * (2 / 3) + this.padding.bottom),
        paint);
  }

  void drawHouses(Canvas canvas, Size size, Paint paint) {
    int houses = this.houses;
    double yFactor = (size.height * (2 / 3)) / houses;
    // Draw Sides
    for (var i = 0; i < houses; i++) {
      double y = (yFactor * i) +
          (yFactor / 2) +
          (size.height * (1 / 3)) -
          (houseHeight / 2);
      Rect rl = Rect.fromLTWH(0, y, houseWidth, houseHeight);
      Rect rr =
          Rect.fromLTWH(size.width - houseWidth, y, houseWidth, houseHeight);
      paint.color = leftColors[i];
      canvas.drawRect(rl, paint);
      paint.color = rightColors[i];
      canvas.drawRect(rr, paint);
    }
  }

  void drawHostpital(Canvas canvas, Size size, Paint paint) {
    Rect hr = Rect.fromLTWH(houseWidth + 20, (size.height / 3) + 5,
        size.width - (houseWidth + 20) * 2, houseHeight);
    paint.color = Colors.white;
    canvas.drawRect(hr, paint);
    int beds = 3;
    for (int i = 0; i < beds; i++) {
      double xFactor = (size.width - (houseWidth + 20) * 2) / beds;
      double x = (xFactor * i) +
          (xFactor / 2) +
          houseWidth +
          20 -
          (blockWidth / 2) -
          4;
      double y =
          (size.height / 3) + 5 + (houseHeight / 2) - (blockHeight / 2) - 4;
      Rect r = Rect.fromLTWH(x, y, blockWidth + 8, blockHeight + 8);
      paint.color = Color.fromRGBO(207, 207, 207, 1);
      canvas.drawRect(r, paint);
      if (this.hospital[i] is Block) {
        drawBlock(canvas, size, paint, this.hospital[i]);
      }
    }
  }

  void drawBlock(Canvas canvas, Size size, Paint paint, Block block) {
    double x = block.x;
    double y = block.y + size.height * (1 / 3);
    paint.color = block.color;
    // Face
    canvas.drawRect(Rect.fromLTWH(x, y, blockWidth, blockHeight), paint);
    paint.color = Colors.black;
    // Left eye
    canvas.drawRect(
        Rect.fromLTWH(
            x + (blockWidth / 4) - (blockWidth / 16),
            y + (blockHeight / 4) - (blockHeight / 16),
            blockWidth / 8,
            blockHeight / 8),
        paint);
    // Right eye
    canvas.drawRect(
        Rect.fromLTWH(
            x + (blockWidth * 3 / 4) - (blockWidth / 16),
            y + (blockHeight / 4) - (blockHeight / 16),
            blockWidth / 8,
            blockHeight / 8),
        paint);
    if (block.infected) {
      paint.color = Colors.white;
      // Mask
      canvas.drawRect(
          Rect.fromLTWH(x + (blockWidth / 4), y + (blockHeight / 2),
              blockWidth / 2, blockHeight / 2),
          paint);
      // Mask Strap
      canvas.drawRect(
          Rect.fromLTWH(x, y + (blockHeight / 2), blockWidth, blockHeight / 16),
          paint);
    } else {
      // Mouth
      canvas.drawArc(
          Rect.fromLTWH(x + (blockWidth / 4), y + (blockHeight / 8) * 3 - 2,
              blockWidth / 2, blockHeight / 2),
          math.pi,
          -math.pi,
          true,
          paint);
    }
  }

  @override
  bool shouldRepaint(GamePainter oldDelegate) => true;
}
