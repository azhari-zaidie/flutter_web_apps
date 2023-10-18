// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_web_1/helpers/api_connection.dart';
import 'package:flutter_web_1/models/staff.dart';
import 'package:flutter_web_1/views/authentication/staffPreferences.dart';
import 'package:flutter_web_1/views/authentication/staff_provider.dart';
import 'package:flutter_web_1/views/list_of_station.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:http/http.dart' as http;

class ScanStaffScreen extends StatefulWidget {
  const ScanStaffScreen({super.key});

  @override
  State<ScanStaffScreen> createState() => _ScanStaffScreenState();
}

class _ScanStaffScreenState extends State<ScanStaffScreen> {
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();

  final GlobalKey _qrKey = GlobalKey();
  QRViewController? _controller;
  String? code;
// Calculate the desired aspect ratio (e.g., 1:1)
  double aspectRatio = 1.0;

  fetchStaffInfo(
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

          print(userInfo.toString());

          await RememberUserPref.storeUserInfo(userInfo);

          Get.toNamed("/listOfStation");
          //Get.offAll(ListOFStationScreen());
          print(StaffClass.fromJson(responseOfGetStaff["staff"]).toString());
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

  /*void _onQRViewCreated(QRViewController controller) {
    final staffProvider = Provider.of<StaffProvider>(context, listen: false);
    setState(() {
      _controller = controller;
      _controller!.scannedDataStream.listen((scanData) async {
        // Handle the scanned QR code data here.
        print(scanData.code);
        print("test");

        if (scanData.code != null) {
          staffProvider.fetchStaffInfo(scanData.code).then((_) {
            // After fetching staff info, navigate to the detail screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListOFStationScreen(),
              ),
            );

            // Stop the camera
            _controller!.stopCamera();
          });
        }
      });
    });
  }*/

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/gradient-bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(16.0),
            //color: Colors.white,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the first section
              //first section
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/intec_logo.png',
                    width: 200,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                          context: context,
                          onCode: (code) async {
                            setState(() {
                              this.code = code;
                              //print(code);
                            });

                            // Split the string by spaces and get the last part

                            List<String> parts = code!.split('= ');
                            String codeNew = parts.last;

                            // Convert the extracted part to an integer
                            //Stro? codeNumber = int.tryParse(codeNew);

                            print("Code scanned:$codeNew");
                            fetchStaffInfo(codeNew);
                          });
                    },
                    child: Text(code ?? "Scan")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
