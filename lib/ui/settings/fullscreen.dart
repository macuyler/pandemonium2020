import 'package:flutter/material.dart';

class FullScreen extends StatefulWidget {
  FullScreen({Key key}) : super(key: key);

  @override
  _FullScreenState createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  bool _useFullScreen = true;

  void handleChange(bool value) {
    setState(() {
      _useFullScreen = value;
    });
  }

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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Switch(
              value: _useFullScreen,
              onChanged: handleChange,
              inactiveTrackColor: Colors.white10,
            ),
            Text('Enable Full Screen',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400)),
          ],
        )
      ],
    );
  }
}
