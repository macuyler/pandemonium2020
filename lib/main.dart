import 'package:flutter/material.dart';
import 'package:pandemonium2020/levelscreen.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Pandemonium',
              style: TextStyle(
                color: Colors.black,
                fontSize: 28
              ),
            ),
            Text('2020',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 70
              ),
            ),
            OutlineButton(
              child: SizedBox(
                width: 140,
                height: 20,
                child: Text('START',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18
                  ),
                ),
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
