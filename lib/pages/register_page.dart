import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_apps/crud_shared_preferences.dart';
import 'package:flutter_apps/http_request.dart';
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
  String _fullName;
  String _loading;
  Size _screenSize;

  @override
  void initState() {
    super.initState();
    _sharedPreferencesCRUD = SharedPreferencesCRUD();
    _tabNumberController = TextEditingController();
    _passportController = TextEditingController();
    _snackBarShow = SnackBarShow();
    _http = HttpRequest();
    _fullName = '';
    _loading = '';
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

  Future<bool> _onBackPressed() {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _snackBarShow.getScaffoldKey(),
        appBar: AppBar(
          title: Text('TCH'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Container(
            width: _screenSize.width * 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _fullName == 'loading'
                    ? CircularProgressIndicator()
                    : Text(_fullName),
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
                _loading != 'input_button'
                    ? RaisedButton(
                        onPressed: () async {
                          if (_tabNumberController.text.length <= 0 ||
                              _passportController.text.length <= 0) {
                            _snackBarShow
                                .snackBarShow('Маълумотларни тўлиқ киритинг!');
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
                            await _sharedPreferencesCRUD
                                .setStringSharedPreferences(
                                    'login', user['username']);
                            Navigator.pop(context);
                          } else {
                            _snackBarShow.snackBarShow(
                                jsonDecode(response.body)['message']);
                            setState(() {
                              _loading = '';
                            });
                          }
                        },
                        child: Center(
                          child: Text('Кириш'),
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
}
