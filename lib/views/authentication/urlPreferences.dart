import 'package:flutter_web_1/helpers/api_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class URL {
  API apiConnection = API();
  setIp(String ip) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //apiConnection.setIp(ip);
    prefs.setString('ip', ip);
  }

  static getIp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ip = prefs.getString('ip');

    if (ip != null) {
      print("ip:  $ip");
    } else {
      print("no URL yet");
    }
    return ip!;
  }
}
