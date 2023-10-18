import 'dart:convert';
import 'package:flutter_web_1/helpers/api_connection.dart';
import 'package:flutter_web_1/models/staff.dart';
import 'package:flutter_web_1/views/list_of_station.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:universal_html/html.dart' as html;

class RememberUserPref {
  //this method to save user info in json format
  static Future<void> storeUserInfo(StaffClass userInfo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userInfo.toJson());

    await preferences.setString("currentUser", userJsonData);
  }

  //read the user info
  //get the data
  static Future<StaffClass?> readUserInfo() async {
    StaffClass? currentUserInfo;

    SharedPreferences preferences = await SharedPreferences.getInstance();

    String? userInfo = preferences.getString("currentUser");

    if (userInfo != null) {
      Map<String, dynamic> userDataMap = jsonDecode(userInfo);
      currentUserInfo = StaffClass.fromJson(userDataMap);
      print(userDataMap);
    } else {
      currentUserInfo = null;
      // ignore: avoid_print
      print("No user info yet");
    }
    return currentUserInfo;
  }

  //remove session
  //remove user info from local storage
  static Future<void> removeUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("currentUser");
  }

  static void fetchStaffInfo(
    String? staffID,
  ) async {
    try {
      var res = await http.get(
        Uri.parse(API.getStaff + staffID!),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        var responseOfGetStaff =
            jsonDecode(res.body); // Notify listeners of the change

        if (responseOfGetStaff["status"] == 1) {
          // Get.to(DetailScreen());
          StaffClass? userInfo =
              StaffClass.fromJson(responseOfGetStaff["staff"]);
          await removeUserInfo();
          print(userInfo.toString());
          await storeUserInfo(userInfo);

          html.window.location.reload();
          //Get.offAll(ListOFStationScreen());
          print(StaffClass.fromJson(responseOfGetStaff["staff"]).toString());
          print("sini");
        } else {
          print("User not foundd");
          print("er: " + staffID);
        }
      } else {}
    } catch (e) {
      print("Error :: $e");
      print("print::  ${API.getStaff + staffID!}");
    }
  }
}
