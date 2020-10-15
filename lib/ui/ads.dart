import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

class Ads extends StatefulWidget {
  bool get isInDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

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

  String unitId = "ca-app-pub-3940256099942544/1033173712"; // Test ID

  void _setUnitId() {
    if (!widget.isInDebugMode) {
      if (Platform.isAndroid) {
        this.unitId = "ca-app-pub-4873890200560512/8350729783"; // Android ID
      } else if (Platform.isIOS) {
        this.unitId = "ca-app-pub-4873890200560512/6702676001"; // iOS ID
      }
    }
  }

  InterstitialAd getAd() {
    return InterstitialAd(
      adUnitId: this.unitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
  }

  @override
  void initState() {
    _setUnitId();
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
