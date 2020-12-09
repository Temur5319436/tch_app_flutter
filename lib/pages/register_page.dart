import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_apps/crud_shared_preferences.dart';
import 'package:flutter_apps/http_request.dart';
import 'package:flutter_apps/pages/list_page_datetime_picture.dart';
import 'package:flutter_apps/snack_bar.dart';
import 'package:flutter_apps/pages/password/buttons.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _tabNumberController;
  TextEditingController _passportController;
  TextEditingController _passwordController;
  SharedPreferencesCRUD _sharedPreferencesCRUD;
  SnackBarShow _snackBarShow;
  HttpRequest _http;
  String _fullName = '';
  String _loading = '';
  Size _screenSize;

  @override
  void initState() {
    super.initState();
    _sharedPreferencesCRUD = SharedPreferencesCRUD();
    _tabNumberController = TextEditingController();
    _passportController = TextEditingController();
    _passwordController = TextEditingController();
    _snackBarShow = SnackBarShow();
    _http = HttpRequest();
  }

  Future<void> loadWorkerFullName() async {
    if (_tabNumberController.text.length <= 0) return;

    setState(() {
      _fullName = 'loading';
    });

    var response = await _http
        .requestGet('/workers/search?tab_number=' + _tabNumberController.text);

    setState(() {
      _fullName = response == null ? '' : response['fullname'];
    });
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _snackBarShow.getScaffoldKey(),
      body: Center(
        child: Container(
          width: _screenSize.width * 0.85,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _fullName == 'loading'
                    ? CircularProgressIndicator()
                    : Text(_fullName),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _tabNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: '1234',
                      labelText: 'Табл номер',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.update),
                        onPressed: () async {
                          loadWorkerFullName();
                        },
                      )),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  onTap: () {
                    loadWorkerFullName();
                  },
                  controller: _passportController,
                  maxLength: 9,
                  decoration: InputDecoration(
                    hintText: 'AB1234567',
                    labelText: 'Пасспорт',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                TextField(
                  onTap: () => loadWorkerFullName(),
                  keyboardType: TextInputType.number,
                  controller: _passwordController,
                  maxLength: 4,
                  decoration: InputDecoration(
                    hintText: 'Парол',
                    labelText: 'Парол',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                _loading != 'input_button'
                    ? OutlineButton(
                        onPressed: () => _register(context),
                        borderSide: BorderSide(color: Colors.black45),
                        child: Container(
                          height: 45,
                          child: Center(
                            child: Text('Рўйхатдан ўтиш'),
                          ),
                        ),
                      )
                    : CircularProgressIndicator()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register(context) async {
    if (_tabNumberController.text.length <= 0) {
      _snackBarShow.snackBarShow('Маълумотларни тўлиқ киритинг!');
      return;
    }
    if (_passportController.text.length <= 0) {
      _snackBarShow.snackBarShow('Паспорт маълумотларни тўлиқ киритинг!');
      return;
    }
    if (_passwordController.text.length <= 0) {
      _snackBarShow.snackBarShow('Паролни узунлиги тўрт хоналик киритинг!');
      return;
    }

    setState(() {
      _loading = 'input_button';
    });

    var response = await _http.requestPost(
        '/workers/register',
        {
          'tab_number': _tabNumberController.text,
          'passport': _passportController.text
        },
        false,
        false);

    if (response.statusCode == 201) {
      var user = jsonDecode(response.body);
      await _sharedPreferencesCRUD.setStringSharedPreferences(
          'login', user['username']);
      await _sharedPreferencesCRUD.setStringSharedPreferences(
          'fullname', user['fullname']);
      await _sharedPreferencesCRUD.setStringSharedPreferences(
          'password', _passwordController.text);
      await _sharedPreferencesCRUD.removeSharedPereferences('list');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ListMoon()));
    } else {
      _snackBarShow.snackBarShow(jsonDecode(response.body)['message']);
      setState(() {
        _loading = '';
      });
    }
  }
}
