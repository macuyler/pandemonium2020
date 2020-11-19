import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/services.dart';

class Ads extends StatefulWidget {
  final Function onClose;
  Ads({Key key, this.onClose}) : super(key: key);

  @override
  _AdsState createState() => _AdsState();
}

class _AdsState extends State<Ads> {
  static String _androidUnitId = "ca-app-pub-4873890200560512/8350729783";
  static String _iosUnitId = "ca-app-pub-4873890200560512/6702676001";

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['games', 'action', 'arcade'],
    contentUrl: '',
    childDirected: false,
    testDevices: <String>[],
  );

  String _unitId = Platform.isAndroid ? _androidUnitId : _iosUnitId;

  InterstitialAd getAd() {
    return InterstitialAd(
      adUnitId: _unitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.closed) {
          SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
          widget.onClose(0);
        } else if (event == MobileAdEvent.clicked) {
          SystemChrome.setEnabledSystemUIOverlays([]);
        } else if (event == MobileAdEvent.failedToLoad) {
          widget.onClose(1);
        }
      },
    );
  }

  @override
  void initState() {
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-4873890200560512~5916138138");
    getAd()
      ..load()
      ..show();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
