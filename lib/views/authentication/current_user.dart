import 'package:flutter_web_1/models/staff.dart';
import 'package:flutter_web_1/views/authentication/staffPreferences.dart';
import 'package:get/get.dart';

class CurrentUser extends GetxController {
  // ignore: prefer_final_fields
  Rx<StaffClass> _currentUser = StaffClass(0, 0, '', '').obs;

  StaffClass get user => _currentUser.value;

  getUserInfo() async {
    StaffClass? getUserInfoFromLocalStorage =
        await RememberUserPref.readUserInfo();
    _currentUser.value = getUserInfoFromLocalStorage!;
  }
}
