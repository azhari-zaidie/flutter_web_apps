import 'dart:convert';
import 'package:flutter_web_1/helpers/api_connection.dart';
import 'package:flutter_web_1/views/list_of_station.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_web_1/models/staff.dart';

class StaffProvider with ChangeNotifier {
  StaffClass? _staffInfo;

  StaffClass? get staffInfo => _staffInfo;

  Future<void> fetchStaffInfo(
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
          _staffInfo = StaffClass.fromJson(responseOfGetStaff["staff"]);
          notifyListeners();
          Get.toNamed("/listOfStation");
          //Get.offAll(ListOFStationScreen());
          print(res.body);
        } else {
          print("User not foundd");
          print("er: " + staffID);
        }
      } else {}
    } catch (e) {
      print("Error :: $e");
      print("sinit:: ");
    }
  }
}
