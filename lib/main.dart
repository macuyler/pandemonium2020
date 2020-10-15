import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/levelscreen.dart';
import './screens/splashscreen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Color.fromRGBO(25, 25, 25, 1),
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          print(snapshot);
          return MaterialApp(
            title: 'Pandemonium 2020',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: snapshot.connectionState == ConnectionState.done &&
                    !snapshot.hasError
                ? HomeScreen()
                : SplashScreen(),
          );
        });
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showLevels = false;

  @override
  Widget build(BuildContext context) {
    return _showLevels
        ? LevelScreen()
        : Scaffold(
            backgroundColor: Color.fromRGBO(25, 25, 25, 1),
            appBar: AppBar(
              brightness: Brightness.dark,
              toolbarHeight: 0,
              backgroundColor: Color.fromRGBO(25, 25, 25, 1),
              elevation: 0,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Pandemonium',
                    style: TextStyle(
                        color: Color.fromRGBO(254, 209, 40, 1),
                        fontSize: 28,
                        shadows: [
                          Shadow(
                              blurRadius: 1.0,
                              color: Color.fromRGBO(250, 28, 22, 1),
                              offset: Offset(1.6, 1.6))
                        ]),
                  ),
                  Text(
                    '2020',
                    style: TextStyle(
                        color: Color.fromRGBO(254, 209, 40, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 70,
                        shadows: [
                          Shadow(
                              blurRadius: 1.0,
                              color: Color.fromRGBO(250, 28, 22, 1),
                              offset: Offset(3.0, 3.0))
                        ]),
                  ),
                  OutlineButton(
                    color: Colors.white,
                    splashColor: Color.fromRGBO(255, 255, 255, 0.6),
                    highlightColor: Color.fromRGBO(255, 255, 255, 0.6),
                    borderSide: BorderSide(
                      color: Color.fromRGBO(255, 255, 255, 0.8),
                      width: 1.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: SizedBox(
                        width: 160,
                        height: 35,
                        child: Center(
                          child: Text(
                            'START',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 22),
                          ),
                        )),
                    onPressed: () {
                      setState(() {
                        _showLevels = true;
                      });
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
