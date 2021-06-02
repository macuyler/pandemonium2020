import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onPressed;
  final bool main;
  ActionButton(
      {Key key, this.text, this.icon, this.onPressed, this.main = false})
      : super(key: key);

  Widget _buildBox(BuildContext context) => SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: 40,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                this.text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(
                  this.icon,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18),
      child: this.main
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: _buildBox(context),
              onPressed: this.onPressed,
            )
          : OutlinedButton(
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                side: BorderSide(
                  color: Color.fromRGBO(255, 255, 255, 0.8),
                  width: 1.0,
                ),
              ),
              child: _buildBox(context),
              onPressed: this.onPressed,
            ),
    );
  }
}
