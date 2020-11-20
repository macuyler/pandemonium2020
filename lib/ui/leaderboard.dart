import 'package:flutter/material.dart';

class Leaderboard extends StatefulWidget {
  final double height;
  Leaderboard({Key key, this.height}) : super(key: key);

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<String> items = ['Hello', 'World'];

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
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(items[index]);
              })
        ],
      )),
    );
  }
}
