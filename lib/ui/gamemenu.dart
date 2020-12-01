import 'package:flutter/material.dart';
import './stars.dart';
import './buttons.dart';
import '../globals.dart';

class GameMenu extends StatefulWidget {
  final double height;
  final int score;
  final int duration;
  final bool isLoading;
  final Function onNextLevel;
  final Function onPlayAgain;
  final Function onSelectLevel;
  GameMenu(
      {Key key,
      this.height,
      this.score,
      this.duration,
      this.isLoading,
      this.onNextLevel,
      this.onPlayAgain,
      this.onSelectLevel})
      : super(key: key);

  @override
  _GameMenuState createState() => _GameMenuState();
}

class _GameMenuState extends State<GameMenu> {
  bool _didStar(int star) =>
      widget.score >= star * (widget.duration / secToStar);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: widget.height,
      child: Stack(children: [
        Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stars(score: widget.score, dur: widget.duration, size: 80),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: Text(_didStar(oneStar) ? 'Level Complete!' : 'Game Over!',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40)),
            ),
            _didStar(oneStar)
                ? ActionButton(
                    text: 'Next Level',
                    icon: Icons.keyboard_arrow_right,
                    onPressed: widget.isLoading ? null : widget.onNextLevel,
                    main: true,
                  )
                : Text(''),
            ActionButton(
              text: 'Play Again',
              icon: Icons.replay,
              main: !_didStar(oneStar),
              onPressed: widget.isLoading ? null : widget.onPlayAgain,
            ),
            ActionButton(
              text: 'Select Level',
              icon: Icons.list,
              onPressed: widget.isLoading ? null : widget.onSelectLevel,
            ),
          ],
        )),
        widget.isLoading
            ? Center(
                child: Container(
                    margin: EdgeInsets.only(top: 120),
                    child: CircularProgressIndicator()))
            : Container(),
      ]),
    );
  }
}
