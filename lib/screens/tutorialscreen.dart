import 'package:flutter/material.dart';

class Step {
  final String title;
  final String description;
  final AssetImage display;
  Step({this.title, this.description, this.display});
}

class TutorialScreen extends StatefulWidget {
  final Function onClose;
  TutorialScreen({Key key, this.onClose}) : super(key: key);

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  int _step = 0;

  List<Step> _steps = [
    Step(
        title: 'How do I play?',
        description:
            'The object of the game is to get as many points as possible by dragging people to the house that matches their color to save them from the Pandemonium!',
        display: AssetImage('assets/tutorial/tut1.gif')),
    Step(
        title: 'What is scooping?',
        description:
            'There is a technique called scooping that can drastically improve your speed! You can scoop by starting to drag at any place on the screen, and then dragging over someone to scoop them up!',
        display: AssetImage('assets/tutorial/tut2.gif')),
    Step(
        title: 'Who are those mask guys?',
        description:
            'If a person is wearing a mask, then they are infected! Infected people will infect others if they get too close! Don\'t let them in the houses!',
        display: AssetImage('assets/tutorial/tut3-android.gif')),
    Step(
        title: 'What is that thing at the top?',
        description:
            'That is the hospital! Drag infected patients in, and after they are better you can drag them back out! But be careful you can only fit 3 people in at a time!',
        display: AssetImage('assets/tutorial/tut4-android.gif')),
    Step(
        title: 'How do I win?',
        description:
            'You get a point for putting a person in the right house, and lose a point for putting them in the wrong one. If someone infected get\'s in a house, it will lose all of it\'s points!',
        display: AssetImage('assets/tutorial/tut5-android.gif')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
        title: Text(_steps[_step].title),
        centerTitle: true,
        brightness: Brightness.dark,
      ),
      backgroundColor: Color.fromRGBO(25, 25, 25, 1),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(top: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            image: DecorationImage(
                              image: _steps[_step].display,
                              fit: BoxFit.cover,
                            )),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width - 40,
                            height: MediaQuery.of(context).size.width - 40)),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12, 20, 12, 10),
                      child: Text(_steps[_step].description,
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlineButton(
                        textColor: Colors.white,
                        onPressed: () => _step - 1 >= 0
                            ? setState(() {
                                _step -= 1;
                              })
                            : {},
                        borderSide: BorderSide(
                          color: Color.fromRGBO(255, 255, 255, 0.8),
                          width: 1.0,
                        ),
                        child: Text('Back', style: TextStyle(fontSize: 16))),
                    OutlineButton(
                        textColor: Colors.blue,
                        onPressed: () => _step + 1 < _steps.length
                            ? setState(() {
                                _step += 1;
                              })
                            : widget.onClose(),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1.0,
                        ),
                        child: Text(_step + 1 < _steps.length ? 'Next' : 'Done',
                            style: TextStyle(fontSize: 16)))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
