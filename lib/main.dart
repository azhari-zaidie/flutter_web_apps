import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_1/helpers/api_connection.dart';
import 'package:flutter_web_1/models/staff.dart';
import 'package:flutter_web_1/views/authentication/staffPreferences.dart';
import 'package:flutter_web_1/views/authentication/staff_provider.dart';
import 'package:flutter_web_1/views/authentication/stationPreferences.dart';
import 'package:flutter_web_1/views/bypass_process.dart';
import 'package:flutter_web_1/views/details.dart';
import 'package:flutter_web_1/views/list_of_station.dart';
import 'package:flutter_web_1/views/scan_staff.dart';
import 'package:flutter_web_1/views/scan_process.dart';
import 'package:flutter_web_1/views/select_station.dart';
import 'package:flutter_web_1/views/test.dart';
import 'package:flutter_web_1/views/testSecond.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => StaffProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Web Apps Terminal',
      theme: ThemeData(
          // Define your app's theme here
          ),
      //home: SelectStationScreen(),
      home: FutureBuilder(
        future: RememberStationPref.readIpInfo(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return YourHomePage();
          } else {
            Future<StaffClass?> userInfo = RememberUserPref.readUserInfo();
            API.initialize();
            // String ip = API.initialize();
            return FutureBuilder(
              future: userInfo,
              builder: (context, userInfoSnapshot) {
                if (userInfoSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Or a loading indicator
                }
                if (userInfoSnapshot.hasError) {
                  return Text('Error: ${userInfoSnapshot.error}');
                }
                final userInfo = userInfoSnapshot.data;

                if (userInfo == null) {
                  print("User Info is null");
                  return ScanStaffScreen();
                } else {
                  print("User Info is not null");
                  return ListOFStationScreen();
                }
              },
            );
            //return const TestSecondScreen();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/', page: () => YourHomePage()),
        GetPage(name: '/listOfStation', page: () => ListOFStationScreen()),
        GetPage(name: '/scanStaff', page: () => ScanStaffScreen()),
        GetPage(name: '/detailsWo', page: () => DetailsWorkOrder()),
        GetPage(name: '/scanProcess', page: () => ScanProcessScreen()),
        GetPage(name: '/selectStation', page: () => SelectStationScreen()),
        GetPage(name: '/scanWoBypass', page: () => ByPassProcessScreen()),
      ],
    );
  }
}

class YourHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedSplashScreen(
        splashIconSize: 250,
        splash: Image.asset('assets/images/logo.png'),
        nextScreen: const SelectStationScreen(),
        backgroundColor: Color(0xFFFFFFFF),
      ),
    );
  }
}
