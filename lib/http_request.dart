import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpRequest {
  final _baseUrl = 'http://192.168.88.184:8000/api';

  _setHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('login');
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$username'));

    var header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': basicAuth
    };

    return header;
  }

  requestPost(url, body, [isJsonDecode = true, isHeaders = true]) async {
    try {
      var headers = await _setHeaders();
      var response;
      if (isHeaders)
        response =
            await http.post(_baseUrl + url, body: body, headers: headers);
      else
        response = await http.post(_baseUrl + url, body: body);
      if (isJsonDecode)
        return jsonDecode(response.body);
      else
        return response;
    } catch (e) {
      return null;
    }
  }

  requestGet(url) async {
    try {
      var headers = await _setHeaders();
      var response = await http.get(_baseUrl + url, headers: headers);
      if (response.statusCode == 200)
        return jsonDecode(response.body);
      else
        return null;
    } catch (e) {
      return null;
    }
  }
}
