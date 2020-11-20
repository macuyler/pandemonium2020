import 'package:flutter/material.dart';
import 'package:pandemonium2020/schemas/leaderboards.dart';
import '../schemas/leaderboards.dart';

class LeaderboardView extends StatefulWidget {
  final double height;
  final Leaderboard leaderboard;
  LeaderboardView({Key key, this.height, this.leaderboard}) : super(key: key);

  @override
  _LeaderboardViewtate createState() => _LeaderboardViewtate();
}

class _LeaderboardViewtate extends State<LeaderboardView> {
  Widget _buildScores() {
    if (widget.leaderboard?.scores != null) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.leaderboard.scores.length,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> entry = widget.leaderboard.scores[index];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(entry['name'], style: TextStyle(color: Colors.white)),
                Text(entry['score'].toString(),
                    style: TextStyle(color: Colors.white))
              ],
            );
          });
    }
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
