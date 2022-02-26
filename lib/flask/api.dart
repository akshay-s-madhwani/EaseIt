// Fetch data from flask API

import 'package:ease_it/utility/ip_address.dart';
import 'package:http/http.dart' as http;

class API {
  getUsage(String society, String licensePlateNo) async {
    var url = Uri.parse(
        'http://$ipAddress:5000/usage?society=$society&licensePlateNo=$licensePlateNo');
    http.Response response;
    try {
      response = await http.get(url);
    } catch (e) {
      print(e.toString());
    }
    if (response == null) {
      throw Exception('Server down! Try again later');
    } else {
      return response.body;
    }
  }

  vehicleExit(String society, String licensePlateNo) async {
    var url = Uri.parse(
        'http://$ipAddress:5000/exit?society=$society&licensePlateNo=$licensePlateNo');
    http.Response response;
    try {
      response = await http.post(url);
    } catch (e) {
      print(e.toString());
    }
    if (response == null) {
      throw Exception('Server down! Try again later');
    } else if (response.statusCode == 400) {
      throw Exception('Something went wrong!');
    } else {
      return response.body;
    }
  }

  vehicleEntry(String society, String licensePlateNo) async {
    var url = Uri.parse(
        'http://$ipAddress:5000/entry?society=$society&licensePlateNo=$licensePlateNo');
    http.Response response;
    try {
      response = await http.post(url);
    } catch (e) {
      print(e.toString());
    }
    if (response == null) {
      throw Exception('Server down! Try again later');
    } else if (response.statusCode == 400) {
      throw Exception('Something went wrong!');
    } else {
      return response.body;
    }
  }

  allocateParking(String society, String stayTime) async {
    var url = Uri.parse(
        'http://$ipAddress:5000/allocate?society=$society&time=$stayTime');
    http.Response response;
    try {
      response = await http.get(url);
    } catch (e) {
      print(e.toString());
    }
    if (response == null) {
      throw Exception('Server down! Try again later');
    } else if (response.statusCode == 400) {
      throw Exception('Something went wrong!');
    } else {
      return response.body;
    }
  }
}
