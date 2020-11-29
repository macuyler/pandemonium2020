import 'package:flutter/material.dart';
import '../../api/settings.dart';

class DisplayName extends StatefulWidget {
  DisplayName({Key key}) : super(key: key);

  @override
  _DisplayNameState createState() => _DisplayNameState();
}

class _DisplayNameState extends State<DisplayName> {
  SettingsApi _settingsApi = new SettingsApi();
  TextEditingController nameController = TextEditingController();
  String _originalName = '';
  String _displayName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _settingsApi.getDisplayName().then((dn) {
      nameController.value = TextEditingValue(text: dn);
      setState(() {
        _originalName = dn;
        _displayName = dn;
        _isLoading = false;
      });
    });
  }

  void _handleChange(String name) {
    setState(() {
      _displayName = name;
    });
  }

  void _handleSubmit() {
    if (_displayName.length > 0 && _displayName != _originalName) {
      _settingsApi.setDisplayName(_displayName);
      setState(() {
        _displayName = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Display Name',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w500)),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 4, 0, 6),
          child: Text('This will appear on the leaderboard.',
              style: TextStyle(color: Colors.white30, fontSize: 12)),
        ),
        TextField(
            controller: nameController,
            onChanged: _handleChange,
            enabled: !_isLoading,
            decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: 2.0, color: Colors.white10)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: 2.0, color: Colors.white30)),
                hintText: _isLoading ? 'Loading...' : 'Display Name',
                hintStyle: TextStyle(color: Colors.white24),
                suffixIcon: IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  iconSize: 18,
                  color: Colors.white,
                  icon: Icon(Icons.check),
                  onPressed:
                      _displayName.length == 0 || _displayName == _originalName
                          ? null
                          : _handleSubmit,
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
