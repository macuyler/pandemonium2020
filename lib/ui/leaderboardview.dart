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
      List<dynamic> scores = List<dynamic>.from(widget.leaderboard.scores);
      scores.sort((a, b) => b['score'] - a['score']);
      return ListView.builder(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: scores.length,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> entry = scores[index];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(entry['name'],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                Text(entry['score'].toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold))
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
