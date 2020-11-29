import 'package:flutter/material.dart';

class FullScreen extends StatelessWidget {
  FullScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Full Screen Game',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w500)),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 4, 0, 6),
          child: Text(
              'This prevents accidental gesture inputs and button presses while playing.',
              style: TextStyle(color: Colors.white30, fontSize: 12)),
        ),
      ],
    );
  }
}
