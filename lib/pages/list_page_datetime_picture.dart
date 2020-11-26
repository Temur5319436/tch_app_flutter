import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_apps/crud_shared_preferences.dart';
import 'package:flutter_apps/http_request.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:zoom_widget/zoom_widget.dart';

class ListMoon extends StatefulWidget {
  DateTime initialDate;

  @override
  _ListMoonState createState() => _ListMoonState();
}

class _ListMoonState extends State<ListMoon> {
  SharedPreferencesCRUD _sharedPreferencesCRUD;
  HttpRequest _httpRequest;
  DateTime _selectedDate;
  Size _size;
  var _list = 'Листок мавжуд емас!';

  @override
  void initState() {
    super.initState();
    _sharedPreferencesCRUD = SharedPreferencesCRUD();
    _httpRequest = HttpRequest();

    _sharedPreferencesCRUD
        .getStringSharedPreferences('list')
        .then((list) => {if (list.length > 0) _list = list});
    _sharedPreferencesCRUD.getStringSharedPreferences('date').then((date) => {
          if (date == null)
            {
              widget.initialDate = DateTime.now(),
              _selectedDate = DateTime.now()
            }
          else
            {
              widget.initialDate = DateTime.parse(date),
              _selectedDate = DateTime.parse(date)
            }
        });
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
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text('Листок'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Container(
            height: _size.height * 0.65,
            width: _size.width * 0.95,
            child: Card(
              shadowColor: Colors.black,
              child: Zoom(
                width: _size.width * 1.2,
                height: _size.height * 0.7,
                backgroundColor: Colors.white,
                onPositionUpdate: (Offset position) {
                  print(position);
                },
                onScaleUpdate: (double scale, double zoom) {
                  print("$scale  $zoom");
                },
                child: Center(
                  child: Text(_list),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton.extended(
            label: Text('Листлар'),
            onPressed: () => {
              showMonthPicker(
                context: context,
                initialDate: _selectedDate ?? widget.initialDate,
                locale: Locale("ru"),
              ).then((date) async {
                if (date != null) {
                  var responseBody =
                      await _httpRequest.requestGet('/lists/get_list/$date');
                  setState(() {
                    _list = responseBody['list'];
                    _selectedDate = date;
                  });
                  _sharedPreferencesCRUD.setStringSharedPreferences(
                      'date', date.toString());
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
