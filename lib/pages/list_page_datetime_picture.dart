import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_apps/crud_shared_preferences.dart';
import 'package:flutter_apps/http_request.dart';
import 'package:flutter_apps/pages/register_page.dart';
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
  String _selectedDateText = '';
  String _userFullName = '';
  Size _size;
  var _user;
  String _list = '';
  bool _loading;

  @override
  void initState() {
    super.initState();
    _sharedPreferencesCRUD = SharedPreferencesCRUD();
    _httpRequest = HttpRequest();
    _loading = false;
    init();
  }

  Future<void> init() async {
    var user = await _sharedPreferencesCRUD.getStringSharedPreferences('login');
    if (user == null) {
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Register(),
          ));
    }
    // await _sharedPreferencesCRUD.removeSharedPereferences('login');

    var responseBody = await _httpRequest.requestGet('/user');
    if (responseBody == null) {
      var userShared =
          await _sharedPreferencesCRUD.getStringSharedPreferences('user');
      _userFullName = userShared;
    } else {
      _userFullName = responseBody['fullname'];
    }

    var list = await _sharedPreferencesCRUD.getStringSharedPreferences('list');
    setState(() {
      if (list != null) {
        _list = list;
      } else {
        _list = 'Листок мавжуд емас!';
      }
    });

    var date = await _sharedPreferencesCRUD.getStringSharedPreferences('date');
    if (date == null) {
      widget.initialDate = DateTime.now();
      _selectedDate = DateTime.now();
    } else {
      widget.initialDate = DateTime.parse(date);
      _selectedDate = DateTime.parse(date);
    }
    _selectedDateText = _selectedDate.toString().substring(0, 7);
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Листок'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 20, right: 20),
            child: GestureDetector(
              onTap: () {},
              child: Text(
                _selectedDateText,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: _size.height * 0.03,
                      ),
                      Text(_userFullName),
                    ],
                  ),
                ),
                Container(
                  height: _size.height * 0.79,
                  alignment: AlignmentGeometry.lerp(
                      Alignment.topCenter, Alignment.topCenter, 20),
                  child: Expanded(
                    child: InteractiveViewer(
                      child: Text(
                        _list,
                        style: TextStyle(fontFamily: 'Consolas', fontSize: 10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: Card(
        shape: StadiumBorder(
            side: BorderSide(
          color: Colors.transparent,
          width: 1.0,
        )),
        elevation: 10.0,
        child: FloatingActionButton.extended(
          label: Text('Листлар'),
          onPressed: () => {
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
                setState(() {
                  _list = responseBody['list'];
                  _selectedDate = date;
                  _loading = false;
                });
                _sharedPreferencesCRUD.setStringSharedPreferences(
                    'list', _list);
              }
            })
          },
          icon: Icon(
            Icons.list_alt,
            size: 40,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
