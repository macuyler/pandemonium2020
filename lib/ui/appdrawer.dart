import 'package:flutter/material.dart';

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
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text('Settings',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Expanded(
                      child: Container(
                          color: Color.fromRGBO(25, 25, 25, 1),
                          child: SafeArea(
                            child: ListView(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              children: [
                                Text('Display Name',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 22)),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 4, 0, 6),
                                  child: Text(
                                      'This will appear on the leaderboard.',
                                      style: TextStyle(
                                          color: Colors.white24, fontSize: 12)),
                                ),
                                TextField(
                                    decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 5),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2.0,
                                                color: Colors.white10)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2.0,
                                                color: Colors.white30)),
                                        hintText: 'Display Name',
                                        hintStyle:
                                            TextStyle(color: Colors.white24),
                                        suffixIcon: IconButton(
                                          visualDensity: VisualDensity.compact,
                                          padding: EdgeInsets.zero,
                                          iconSize: 18,
                                          color: Colors.white,
                                          icon: Icon(Icons.check),
                                          onPressed: () {},
                                          tooltip: 'Save',
                                        ),
                                        suffixIconConstraints:
                                            BoxConstraints.loose(
                                                Size.fromHeight(18))),
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                          )),
                    ),
                  ],
                ))));
  }
}
