import 'package:flutter/material.dart';

class TutorialScreen extends StatefulWidget {
  final Function onClose;
  TutorialScreen({Key key, this.onClose}) : super(key: key);

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  int _step = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text('How To Play'),
        centerTitle: true,
        brightness: Brightness.dark,
      ),
      backgroundColor: Color.fromRGBO(25, 25, 25, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the Tutorial',
                style: TextStyle(color: Colors.white)),
            Text('$_step'),
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
                      'Play Now',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 22),
                    ),
                  )),
              onPressed: widget.onClose,
            ),
          ],
        ),
      ),
    );
  }
}
