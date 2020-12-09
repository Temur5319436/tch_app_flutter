import 'package:flutter/material.dart';
import 'package:flutter_apps/crud_shared_preferences.dart';
import 'package:flutter_apps/pages/list_page_datetime_picture.dart';
import 'package:flutter_apps/pages/password/buttons.dart';
import 'package:flutter_apps/pages/register_page.dart';
import 'package:flutter_apps/snack_bar.dart';

class Password extends StatefulWidget {
  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  var _dotButtons = [false, false, false, false];
  SharedPreferencesCRUD _sharedPreferencesCRUD;
  SnackBarShow _snackBarShow;
  String _inputPasswordText = '';
  String _basePassword = '';
  double _buttonSize = 0;
  double _dotSize = 0;
  Size _size;

  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    _sharedPreferencesCRUD = SharedPreferencesCRUD();
    _snackBarShow = SnackBarShow();

    _basePassword =
        await _sharedPreferencesCRUD.getStringSharedPreferences('password');
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _buttonSize = _size.width * 0.2;
    _dotSize = _size.width * 0.05;

    return Scaffold(
      key: _snackBarShow.getScaffoldKey(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Паролни киритинг',
                style: TextStyle(fontSize: 25.0, color: Colors.blue),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _getCricleDot(0),
                _getCricleDot(1),
                _getCricleDot(2),
                _getCricleDot(3),
              ],
            ),
          ),
          PasswordButtons(
              buttonSize: _buttonSize,
              setPassword: _setPassword,
              getItem: _getItem,
              basePassword: _basePassword),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
            child: OutlineButton(
              onPressed: () => _register(),
              borderSide: BorderSide(color: Colors.blue),
              child: Center(
                child: Text(
                  'Рўйхатдан ўтиш',
                  style: TextStyle(fontSize: 14, color: Colors.blue),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildFloatActionButton(int n, double size) {
    return InkWell(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
      onTap: () {
        _setPassword(n);
      },
      hoverColor: Colors.blue,
      splashColor: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: new BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          height: size,
          width: size,
          child: Center(child: _getItem(n)),
        ),
      ),
    );
  }

  _getItem(int n) {
    if (n >= 0) {
      return Text(
        n.toString(),
        style: TextStyle(
          fontSize: 25,
          color: Colors.blue[800],
        ),
      );
    } else if (n == -1) {
      return Icon(
        Icons.backspace,
        color: Colors.blue[800],
      );
    } else {
      return Icon(
        Icons.clear,
        color: Colors.blue[800],
      );
    }
  }

  _setPassword(int intPassword) {
    if (intPassword >= 0)
      _inputPasswordText += intPassword.toString();
    else if (intPassword == -1 && _inputPasswordText.length > 1) {
      _inputPasswordText =
          _inputPasswordText.substring(0, _inputPasswordText.length - 1);

      setState(() {
        if (_inputPasswordText.length == 0)
          _dotButtons[0] = false;
        else if (_inputPasswordText.length == 1)
          _dotButtons[1] = false;
        else if (_inputPasswordText.length == 2)
          _dotButtons[2] = false;
        else if (_inputPasswordText.length == 3) _dotButtons[3] = false;
      });
    } else {
      _clearPassword();
    }

    setState(() {
      if (_inputPasswordText.length == 1)
        _dotButtons[0] = true;
      else if (_inputPasswordText.length == 2)
        _dotButtons[1] = true;
      else if (_inputPasswordText.length == 3)
        _dotButtons[2] = true;
      else if (_inputPasswordText.length == 4) _dotButtons[3] = true;
    });

    if (_inputPasswordText.length < 4) return;

    if (_basePassword == _inputPasswordText) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ListMoon()));
    } else {
      _clearPassword();
      _snackBarShow.snackBarShow('Парол нотўғри!');
    }
  }

  _getCricleDot(int i) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: _dotSize,
        decoration: BoxDecoration(
          color: _dotButtons[i] ? Colors.blue : Colors.transparent,
          border: Border.all(color: Colors.blue),
        ),
        width: _dotSize,
      ),
    );
  }

  Future<void> _clearPassword() {
    _inputPasswordText = '';
    setState(() {
      _dotButtons[0] = false;
      _dotButtons[1] = false;
      _dotButtons[2] = false;
      _dotButtons[3] = false;
    });
  }

  Future<void> _register() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Register()));
  }
}
