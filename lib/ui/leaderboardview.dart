import 'package:flutter/material.dart';
import '../schemas/levels.dart';

class LeaderboardView extends StatefulWidget {
  final double height;
  final Level level;
  LeaderboardView({Key key, this.height, this.level}) : super(key: key);

  @override
  _LeaderboardViewtate createState() => _LeaderboardViewtate();
}

class _LeaderboardViewtate extends State<LeaderboardView> {
  Widget _buildScores() {
    print(widget.level.leaderboard);
    // if (widget.leaderboard?.scores != null) {
    //   return ListView.builder(
    //       scrollDirection: Axis.vertical,
    //       shrinkWrap: true,
    //       itemCount: widget.leaderboard.scores.length,
    //       itemBuilder: (BuildContext context, int index) {
    //         print(widget.leaderboard.scores[index]);
    //         return Text('hello');
    //       });
    // }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: widget.height,
      padding: EdgeInsets.fromLTRB(5, 20, 5, 10),
      child: Center(
          child: Column(
        children: [
          Text(
            'Leaderboard',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
          ),
          _buildScores(),
        ],
      )),
    );
  }
}
