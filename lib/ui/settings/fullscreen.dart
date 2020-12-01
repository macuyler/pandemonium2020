import 'package:flutter/material.dart';
import '../../api/settings.dart';

class FullScreen extends StatefulWidget {
  FullScreen({Key key}) : super(key: key);

  @override
  _FullScreenState createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  SettingsApi _settingsApi = new SettingsApi();
  bool _useFullScreen = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _settingsApi.getUseFullScreen().then((ufs) {
      setState(() {
        _useFullScreen = ufs;
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _settingsApi.setUseFullScreen(_useFullScreen);
  }

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
              onChanged: _isLoading ? null : handleChange,
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
