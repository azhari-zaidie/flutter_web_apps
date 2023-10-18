import 'package:flutter/material.dart';
import 'package:flutter_web_1/models/staff.dart';

class StaffInfoProvider with ChangeNotifier {
  StaffClass? _staffInfo; // Store user information

  StaffClass? get staffInfo => _staffInfo;

  // Method to update user information
  void setStaffInfo(StaffClass staffInfo) {
    _staffInfo = staffInfo;
    notifyListeners(); // Notify listeners of the change
  }
}
