import 'package:flutter/material.dart';
import './screens/levelscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pandemonium 2020',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
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
    return _showLevels ? LevelScreen() : Scaffold(
      backgroundColor: Color.fromRGBO(25, 25, 25, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Pandemonium',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28
              ),
            ),
            Text('2020',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 70
              ),
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
                borderRadius: BorderRadius.circular(45),
              ),
              child: SizedBox(
                width: 160,
                height: 45,
                child: Center(
                  child: Text('START',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 26
                    ),
                  ),
                )
              ),
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
