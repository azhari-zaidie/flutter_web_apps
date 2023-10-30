import 'package:flutter_web_1/views/authentication/urlPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class API {
  static String? hostAPI;

  static Future<void> storeUrl(String stationIpId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //String userJsonData = jsonEncode(userInfo.toJson());

    await preferences.setString("ip", stationIpId);
  }

  static Future<String> initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ip = prefs.getString("ip");
    print("siniiii $ip");
    hostAPI = ip;
    return ip!;
  }

  static Future<void> removeUrl() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("ip");
  }

  static final getStaff = "$hostAPI/api/get_operator-api?staff_id=";

  static final getStation = "$hostAPI/api/get_list_station?staff_id=";

  static final getWo = "$hostAPI/api/get_wo";

  static final getWoProgressRecord = "$hostAPI/api/get_wo_progress_record";

  static final getWoList = "$hostAPI/api/get_wo_traveller?station_id=";

  static final updateQty = "$hostAPI/api/get_quantity";

  static final addProgressRecord = "$hostAPI/api/add_progress_record";

  static final getDrawing = "$hostAPI/api/get_drawing?bom_process_id=";

  static final getSkipAllProcess = "$hostAPI/api/bypass_process";

  static final getTraveller = "$hostAPI/api/traveller?wo_id=";

  static final getDownloadFile = "$hostAPI/";
  // https://erp.inteceng.com.my/${eachDrawing.url!}

  static final getTravellerProcess =
      "$hostAPI/api/generated-process-traveller?id=";
}

/*
class API {
  static const hostAPI = "http://192.168.22.2/intec-erp/public";

  static const getStaff = "$hostAPI/api/get_operator-api?staff_id=";

  static const getStation = "$hostAPI/api/get_list_station?staff_id=";

  static const getWo = "$hostAPI/api/get_wo";

  static const getWoProgressRecord = "$hostAPI/api/get_wo_progress_record";

  static const getWoList = "$hostAPI/api/get_wo_traveller?station_id=";

  static const updateQty = "$hostAPI/api/get_quantity";

  static const addProgressRecord = "$hostAPI/api/add_progress_record";

  static const getDrawing = "$hostAPI/api/get_drawing?bom_process_id=";

  static const getSkipAllProcess = "$hostAPI/api/bypass_process";

  static const getTraveller = "$hostAPI/api/traveller?wo_id=";

  static const getDownloadFile = "$hostAPI/";
  // https://erp.inteceng.com.my/${eachDrawing.url!}
}
*/
