import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_web_1/helpers/api_connection.dart';
import 'package:flutter_web_1/helpers/decoration.dart';
import 'package:flutter_web_1/models/staff.dart';
import 'package:flutter_web_1/models/station.dart';
import 'package:flutter_web_1/views/authentication/current_user.dart';
import 'package:flutter_web_1/views/authentication/staffPreferences.dart';
import 'package:flutter_web_1/views/authentication/staff_provider.dart';
import 'package:flutter_web_1/views/authentication/stationPreferences.dart';
import 'package:flutter_web_1/views/details.dart';
import 'package:flutter_web_1/views/scan_staff.dart';
import 'package:flutter_web_1/views/select_station.dart';
import 'package:flutter_web_1/views/test.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';

class ListOFStationScreen extends StatefulWidget {
  const ListOFStationScreen({super.key});

  @override
  State<ListOFStationScreen> createState() => _ListOFStationScreenState();
}

class _ListOFStationScreenState extends State<ListOFStationScreen> {
  //final CurrentUser _currentUser = Get.put(CurrentUser());
  StaffClass? _currentUser;
  int? _station;

  String? detail;

  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  Future<void> _loadUserInfo() async {
    final user = await RememberUserPref.readUserInfo();
    if (user != null) {
      setState(() {
        _currentUser = user;
        detail = "${_currentUser!.fullName} - ${_currentUser!.staff_id}";
      });
    }
  }

  Future<void> _loadStationInfo() async {
    final station = await RememberStationPref.readIpInfo();
    if (station != null) {
      setState(() {
        _station = station;
      });
    }
  }

  //StaffClass? currentUserInfo = RememberUserPref.readUserInfo();

  String ip_address = "";
  String? ipAddress;
  /*Future<void> fetchIPAddress() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4) {
          setState(() {
            ipAddress = addr.address;
          });
          return;
        }
      }
    }
  }*/

  Future<List<Station>> getListStation() async {
    //final staffProvider = Provider.of<StaffProvider>(context);
    List<Station> listStation = [];

    try {
      var res = await http.get(
          Uri.parse(
            //passing staff id and station ip
            "${API.getStation}${_currentUser!.staff_id.toString()}&station_ip_id=${_station.toString()}",
          ),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          });
      if (res.statusCode == 200) {
        var responseOfGetStation = jsonDecode(res.body);
        if (responseOfGetStation["status"] == 1) {
          (responseOfGetStation["station"] as List).forEach((element) {
            listStation.add(Station.fromJson(element));
          });

          ip_address = responseOfGetStation["station_ip"][0]["ip_address"];

          //print(responseOfGetStation["station_ip"][0]["ip_address"]);
        } else {
          print(
              "${API.getStation}${_currentUser!.staff_id.toString()}&station_ip_id=12");
          print("here");
        }
      } else {
        print(
            "${API.getStation}${_currentUser!.staff_id.toString()}&station_ip_id=12");
      }
    } catch (e) {
      print(
          "${API.getStation}${_currentUser!.staff_id.toString()}&station_ip_id=${_station.toString()}");
    }

    return listStation;
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    // fetchIPAddress();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserInfo();
    _loadStationInfo();
    API.initialize();
  }

  @override
  Widget build(BuildContext context) {
    //staffProvider.fetchStaffInfo("2269");
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/gradient-bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1.0,
            ),
            color: Colors.white,
          ),
          height: MediaQuery.of(context).size.height * 1,
          padding: EdgeInsets.all(16.0),
          //color: Colors.white,
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center the first section
            //first section
            children: [
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle the QR code button press here

                      //Get.to(ScannWOScreen(eachStation: widget.eachStation));

                      _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                          context: context,
                          onCode: (code) async {
                            // Split the string by spaces and get the last part

                            List<String> parts = code!.split('= ');
                            String codeNew = parts.last;

                            // Convert the extracted part to an integer
                            //Stro? codeNumber = int.tryParse(codeNew);

                            print("Code scanned:$codeNew");
                            RememberUserPref.fetchStaffInfo(codeNew);
                          });
                    },
                    icon: Icon(Icons.qr_code),
                    label: Text(
                      'Scan Staff',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Spacer(),
                  Center(
                    child: Image.asset(
                      'assets/images/intec_logo.png',
                      width: 200,
                    ),
                  ),
                  Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle the QR code button press here

                      //Get.to(ScannWOScreen(eachStation: widget.eachStation));
                      RememberStationPref.removeStationInfo().then((value) =>
                          Get.toNamed("/selectStation", arguments: "done"));
                    },
                    icon: Icon(Icons.logout_rounded),
                    label: Text(
                      'Select Station',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (detail!.isEmpty)
                        ? "Loading..."
                        : "${_currentUser!.fullName} - ${_currentUser!.staff_id}",
                  ),
                ],
              ),
              //section section
              Expanded(
                child: Center(child: listOfStation(context)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget listOfStation(context) {
    return FutureBuilder(
      future: getListStation(),
      builder: (context, AsyncSnapshot<List<Station>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (dataSnapShot.data == null) {
          return const Center(
            child: Text("No List Of Station for This Staff ID"),
          );
        }

        if (dataSnapShot.data!.length > 0) {
          return Container(
            padding: EdgeInsets.all(16),
            color: Colors.white, // Background color
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical, // Scroll vertically
              child: Column(
                children: [
                  for (int index = 0;
                      index < dataSnapShot.data!.length;
                      index += 4)
                    Row(
                      children: [
                        for (int i = index;
                            i < index + 4 && i < dataSnapShot.data!.length;
                            i++)
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Station eachStation = dataSnapShot.data![i];
                                print(eachStation.stationIpId.toString());
                                Get.toNamed("/detailsWo",
                                    arguments: eachStation);
                                // Handle item click here
                                // Get.to(DetailsWorkOrder(
                                //   eachStation: eachStation,
                                // ));
                              },
                              child: Card(
                                child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/images/setting.gif',
                                          width: 100,
                                        ),
                                        Text(
                                          dataSnapShot.data![i].name!,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text("Empty, No Data"),
            ),
          );
        }
      },
    );
  }
}
