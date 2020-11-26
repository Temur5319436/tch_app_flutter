import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_apps/crud_shared_preferences.dart';
import 'package:flutter_apps/http_request.dart';
import 'package:flutter_apps/pages/list_page_datetime_picture.dart';
import 'package:flutter_apps/pages/lists_page.dart';
import 'package:flutter_apps/snack_bar.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _tabNumberController;
  TextEditingController _passportController;
  SharedPreferencesCRUD _sharedPreferencesCRUD;
  SnackBarShow _snackBarShow;
  HttpRequest _http;
  var _fullName;
  var _screenSize;

  @override
  void initState() {
    super.initState();
    _sharedPreferencesCRUD = SharedPreferencesCRUD();
    _tabNumberController = TextEditingController();
    _passportController = TextEditingController();
    _snackBarShow = SnackBarShow();
    _http = HttpRequest();
    _fullName = '';

    _sharedPreferencesCRUD
        .getStringSharedPreferences('login')
        .then((value) async {
      if (value != null) {
        await login();
      }
    });
  }

  Future<void> login() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ListMoon()));
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
      appBar: AppBar(
        title: Text('TCH'),
      ),
      body: Center(
        child: Container(
          width: _screenSize.width * 0.85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _fullName == 'loading'
                  ? CircularProgressIndicator()
                  : Text(
                      _fullName,
                      style: TextStyle(fontSize: 18.0),
                    ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _tabNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: '1234',
                    labelText: 'Табл номер',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.update),
                      onPressed: () async {
                        loadWorkerFullName();
                      },
                    )),
                autofocus: false,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                onTap: () {
                  loadWorkerFullName();
                },
                controller: _passportController,
                decoration: InputDecoration(
                  hintText: 'AB1234567',
                  labelText: 'Пасспорт',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                onPressed: () async {
                  if (_tabNumberController.text.length <= 0 ||
                      _passportController.text.length <= 0) {
                    _snackBarShow.snackBarShow('Маълумотларни тўлиқ киритинг!');
                    return;
                  }

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
                    await login();
                  } else {
                    _snackBarShow
                        .snackBarShow(jsonDecode(response.body)['message']);
                  }
                },
                child: Center(
                  child: Text('Кириш'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
