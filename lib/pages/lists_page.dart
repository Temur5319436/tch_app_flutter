import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class List extends StatefulWidget {
  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<List> {
  String _year;
  Size _size;

  Future<bool> _onBackPressed() {
    SystemNavigator.pop();
  }

  @override
  void initState() {
    super.initState();
    _year = DateTime.now().year.toString();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Листок'),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          color: Colors.grey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: _size.width * 0.3,
                        width: _size.width * 0.3,
                        child: Center(child: Text('Январь')),
                      ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: _size.width * 0.3,
                        width: _size.width * 0.3,
                        child: Center(child: Text('Февраль')),
                      ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: _size.width * 0.3,
                        width: _size.width * 0.3,
                        child: Center(child: Text('Март')),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: _size.width * 0.3,
                        width: _size.width * 0.3,
                        child: Center(child: Text('Апрель')),
                      ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: _size.width * 0.3,
                        width: _size.width * 0.3,
                        child: Center(child: Text('Май')),
                      ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: _size.width * 0.3,
                        width: _size.width * 0.3,
                        child: Center(child: Text('Июнь')),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: _size.width * 0.3,
                        width: _size.width * 0.3,
                        child: Center(child: Text('Июль')),
                      ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: _size.width * 0.3,
                        width: _size.width * 0.3,
                        child: Center(child: Text('Август')),
                      ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: _size.width * 0.3,
                        width: _size.width * 0.3,
                        child: Center(child: Text('Сентябрь')),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: _size.width * 0.3,
                        width: _size.width * 0.3,
                        child: Center(child: Text('Октябрь')),
                      ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: _size.width * 0.3,
                        width: _size.width * 0.3,
                        child: Center(child: Text('Ноябрь')),
                      ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: _size.width * 0.3,
                        width: _size.width * 0.3,
                        child: Center(child: Text('Декабрь')),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: _size.width * 0.95,
                child: RaisedButton(
                  onPressed: () {},
                  child: Center(
                    child: Text(
                      'Охирги листокни кўриш',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 1,
          onTap: (value) {
            setState(() {
              if (value == 0) {
                _year = (int.parse(_year) - 1).toString();
              } else {
                _year = (int.parse(_year) + 1).toString();
              }
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.arrow_back,
                size: 35,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Text(
                _year,
                style: TextStyle(fontSize: 20),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.arrow_forward,
                size: 35,
              ),
              label: '',
            ),
          ],
          selectedItemColor: Colors.amber[800],
        ),
      ),
    );
  }
}
