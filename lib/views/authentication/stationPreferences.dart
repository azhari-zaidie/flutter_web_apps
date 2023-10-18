import 'package:shared_preferences/shared_preferences.dart';

class RememberStationPref {
  //this method to save user info in json format
  static Future<void> storeIpInfo(int stationIpId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //String userJsonData = jsonEncode(userInfo.toJson());

    await preferences.setInt("currentStation", stationIpId);
  }

  //read the user info
  //get the data
  static Future<int?> readIpInfo() async {
    int? currentStationInfo;

    SharedPreferences preferences = await SharedPreferences.getInstance();

    int? ipInfo = preferences.getInt("currentStation");

    if (ipInfo != null) {
      //Map<String, dynamic> userDataMap = jsonDecode(userInfo);
      currentStationInfo = ipInfo;
      print(currentStationInfo);
    } else {
      // ignore: avoid_print
      print("No station info yet");
    }
    return currentStationInfo;
  }

  //remove session
  //remove user info from local storage
  static Future<void> removeStationInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("currentStation");
  }
}
