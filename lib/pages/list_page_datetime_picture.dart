import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_apps/crud_shared_preferences.dart';
import 'package:flutter_apps/http_request.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class ListMoon extends StatefulWidget {
  DateTime initialDate;

  @override
  _ListMoonState createState() => _ListMoonState();
}

class _ListMoonState extends State<ListMoon> {
  SharedPreferencesCRUD _sharedPreferencesCRUD;
  HttpRequest _httpRequest;
  DateTime _selectedDate;
  String _selectedDateText = '2019-12';
  String _userFullName = '';
  Size _size;
  String _list = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _sharedPreferencesCRUD = SharedPreferencesCRUD();
    _httpRequest = HttpRequest();
    init();
  }

  Future<void> init() async {
    String fullName =
        await _sharedPreferencesCRUD.getStringSharedPreferences('fullname');
    String list =
        await _sharedPreferencesCRUD.getStringSharedPreferences('list');
    setState(() {
      _userFullName = fullName;
      if (list != '') {
        _list = list;
      } else {
        _list = 'Листок мавжуд емас!';
      }
    });

    String date =
        await _sharedPreferencesCRUD.getStringSharedPreferences('date');
    if (date == '') {
      widget.initialDate = DateTime.now();
      _selectedDate = DateTime.now();
    } else {
      widget.initialDate = DateTime.parse(date);
      _selectedDate = DateTime.parse(date);
    }
    _selectedDateText = _selectedDate.toString().substring(0, 7);
  }

  Future<bool> _onBackPressed() {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_userFullName),
              SizedBox(
                height: 5,
              ),
              Text(
                _selectedDateText.toString(),
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey[300],
                ),
              )
            ],
          ),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: IconButton(
                onPressed: () => showCalendar(),
                icon: Icon(Icons.date_range),
              ),
            ),
          ],
        ),
        body: _loading
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: InteractiveViewer(
                      child: Center(
                        child: Text(
                          _list,
                          style: TextStyle(
                            fontFamily: 'Consolas',
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> showCalendar() {
    showMonthPicker(
      context: context,
      initialDate: _selectedDate ?? widget.initialDate,
      locale: Locale("ru"),
    ).then((date) async {
      if (date != null) {
        setState(() {
          _loading = true;
        });
        var responseBody =
            await _httpRequest.requestGet('/lists/get_list/$date');
        _sharedPreferencesCRUD.setStringSharedPreferences(
            'date', date.toString());
        if (responseBody == null) {
          setState(() {
            _list = 'Листок мавжуд емас!';
            _selectedDate = date;
            _selectedDateText = date.toString().substring(0, 7);
            _loading = false;
          });
          _sharedPreferencesCRUD.setStringSharedPreferences('list', _list);
        } else {
          setState(() {
            _list = responseBody['list'];
            _selectedDate = date;
            _selectedDateText = date.toString().substring(0, 7);
            _loading = false;
          });
          _sharedPreferencesCRUD.setStringSharedPreferences('list', _list);
        }
      }
    });
  }
}
