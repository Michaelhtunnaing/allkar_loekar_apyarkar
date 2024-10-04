import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../error/error.dart';

class DataService {
  Future<Object> getApi(String url) async {
    try {
      Uri uri = Uri.parse(url);
      final data = await http.get(uri);
      if (data.statusCode == 200) {
        return Success(code: 200, object: data.body);
      } else {
        return Failture(object: "No Data Get", code: 202);
      }
    } on SocketException {
      return Failture(object: "No Internet Connection", code: 202);
    } on FormatException {
      return Failture(object: "Json Format Error", code: 204);
    } on HttpException {
      return Failture(object: "Url Error", code: 404);
    } catch (e) {
      return Failture(code: 202, object: "Unknown Error");
    }
  }
}
