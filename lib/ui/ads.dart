import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

class Ads extends StatefulWidget {
  @override
  _AdsState createState() => _AdsState();
}

class _AdsState extends State<Ads> {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['games', 'action', 'arcade'],
    contentUrl: '',
    childDirected: false,
    testDevices: <String>[],
  );

  InterstitialAd myInterstitial = InterstitialAd(
    adUnitId: Platform.isAndroid
        ? "ca-app-pub-4873890200560512/8350729783"
        : "ca-app-pub-4873890200560512/6702676001",
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event is $event");
    },
  );

  @override
  void initState() {
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-4873890200560512~5916138138");
    myInterstitial
      ..load()
      ..show();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
