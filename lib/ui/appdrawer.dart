import 'package:flutter/material.dart';
import './settings/displayname.dart';

class AppDrawer extends StatefulWidget {
  AppDrawer({Key key}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
            color: Colors.blue,
            child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text('Settings',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Container(
                        color: Color.fromRGBO(25, 25, 25, 1),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 20,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                          ),
                        )),
                    Expanded(
                      child: Container(
                          color: Color.fromRGBO(25, 25, 25, 1),
                          child: SafeArea(
                            child: ListView(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              children: [
                                DisplayName(),
                              ],
                            ),
                          )),
                    ),
                  ],
                ))));
  }
}
