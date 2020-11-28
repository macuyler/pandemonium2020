import 'package:flutter/material.dart';

class DisplayName extends StatefulWidget {
  DisplayName({Key key}) : super(key: key);

  @override
  _DisplayNameState createState() => _DisplayNameState();
}

class _DisplayNameState extends State<DisplayName> {
  TextEditingController nameController = TextEditingController();
  String _displayName = '';

  void _handleChange(String name) {
    setState(() {
      _displayName = name;
    });
  }

  void _handleSubmit() {
    print('Name: $_displayName');
    nameController.clear();
    setState(() {
      _displayName = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Display Name',
            style: TextStyle(color: Colors.white, fontSize: 22)),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 4, 0, 6),
          child: Text('This will appear on the leaderboard.',
              style: TextStyle(color: Colors.white24, fontSize: 12)),
        ),
        TextField(
            controller: nameController,
            onChanged: _handleChange,
            decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0, color: Colors.white10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0, color: Colors.white30)),
                hintText: 'Display Name',
                hintStyle: TextStyle(color: Colors.white24),
                suffixIcon: IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  iconSize: 18,
                  color: Colors.white,
                  icon: Icon(Icons.check),
                  onPressed: _displayName.length == 0 ? null : _handleSubmit,
                  tooltip: 'Save',
                ),
                suffixIconConstraints:
                    BoxConstraints.loose(Size.fromHeight(18))),
            style: TextStyle(
              color: Colors.white,
            )),
      ],
    );
  }
}
