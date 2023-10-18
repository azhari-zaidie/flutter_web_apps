import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_web_1/helpers/api_connection.dart';
import 'package:flutter_web_1/models/staff.dart';
import 'package:flutter_web_1/models/station.dart';
import 'package:flutter_web_1/models/traveller.dart';
import 'package:flutter_web_1/views/authentication/staffPreferences.dart';
import 'package:flutter_web_1/views/authentication/staff_provider.dart';
import 'package:flutter_web_1/views/controller/processController.dart';
import 'package:flutter_web_1/views/details.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

class ScanProcessScreen extends StatefulWidget {
  //final Station? eachStation;
  final eachStation = Get.arguments as Station?;
  ScanProcessScreen({super.key});

  @override
  State<ScanProcessScreen> createState() => _ScanProcessScreenState();
}

class _ScanProcessScreenState extends State<ScanProcessScreen> {
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  TextEditingController qty = TextEditingController();
  // final controller = MyControllerProcess();
  final MyControllerProcess _textEditingController =
      Get.put(MyControllerProcess());
  final GlobalKey _qrKey = GlobalKey();
  QRViewController? _controller;
// Calculate the desired aspect ratio (e.g., 1:1)
  double aspectRatio = 1.0;
  StaffClass? _currentUser;
  Future<void> _loadUserInfo() async {
    final user = await RememberUserPref.readUserInfo();
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  fetchWoDetails(String? woID) async {
    List<Processtraveller> getProcessTraveller = [];
    try {
      var resCheckStation = await http.post(
        Uri.parse(API.getWo),
        body: {
          'wo_id': woID,
          'station_id': widget.eachStation!.stationId.toString(),
        },
      );

      if (resCheckStation.statusCode == 200) {
        var responseOfGetProcessTraveller = jsonDecode(resCheckStation.body);
        if (responseOfGetProcessTraveller["success"] == true) {
          // (responseOfGetProcessTraveller["processtraveller"] as List)
          //     .forEach((element) {
          //   getProcessTraveller.add(Processtraveller.fromJson(element));
          // });
          if (responseOfGetProcessTraveller["wo_status"] == 12) {
            Fluttertoast.showToast(
              msg: "Fail to start! Work Order has been cancelled. ",
              timeInSecForIosWeb: 5,
            );
          } else if (responseOfGetProcessTraveller["wo_status"] == 14) {
            Fluttertoast.showToast(
              msg: "Fail to start! Work Order is already closed. ",
              timeInSecForIosWeb: 5,
            );
          } else if (responseOfGetProcessTraveller["processTravellerStatus"] ==
              -1) {
            //Cannot find BOM Process
            Fluttertoast.showToast(
              msg: "Fail to find BOM Process for this Work Order! ",
              timeInSecForIosWeb: 5,
            );
          } else if (responseOfGetProcessTraveller["processTravellerStatus"] ==
              -2) {
            //WO Has Been Registered
            Fluttertoast.showToast(
              msg: "Work Order Has Been Registered! ",
              timeInSecForIosWeb: 5,
            );
          } else if (responseOfGetProcessTraveller["processTravellerStatus"] ==
              -3) {
            //check child not close
            Fluttertoast.showToast(
              msg: "Child Work Order not closed!",
              timeInSecForIosWeb: 5,
            );
          } else if (responseOfGetProcessTraveller["processTravellerStatus"] ==
              0) {
            //No process traveller detected
            Fluttertoast.showToast(
              msg: "No process traveller detected! ",
              timeInSecForIosWeb: 5,
            );
          } else if (responseOfGetProcessTraveller["processTravellerStatus"] ==
              1) {
            //process traveller existed
            if (responseOfGetProcessTraveller["previousProcessStatus"] ==
                null) {
              //previous process is not initialized
              Fluttertoast.showToast(
                msg:
                    "Previous process ${responseOfGetProcessTraveller["previous_process_name"]} has NOT BEEN INITIALIZED yet! Please wait until it is completed. Try again later!",
                timeInSecForIosWeb: 5,
              );
            } else if (responseOfGetProcessTraveller["previousProcessStatus"] ==
                0) {
              //previous process is on initiliazation
              Fluttertoast.showToast(
                msg:
                    "Previous process ${responseOfGetProcessTraveller["previous_process_name"]} is on INITIALIZATION! Please wait until it is completed. Try again later!",
                timeInSecForIosWeb: 5,
              );
            } else if (responseOfGetProcessTraveller["previousProcessStatus"] ==
                1) {
              //previous process is on progress
              Fluttertoast.showToast(
                msg:
                    "Previous process ${responseOfGetProcessTraveller["previous_process_name"]} is still ON PROGRESS! Please wait until it is completed. Try again later!",
                timeInSecForIosWeb: 5,
              );
            } else if (responseOfGetProcessTraveller["previousProcessStatus"] ==
                -1) {
              //current process has no input
              Fluttertoast.showToast(
                msg:
                    "The current process has no INPUT. Please ask the responsible person to complete BOM details!",
                timeInSecForIosWeb: 5,
              );
            } else if (responseOfGetProcessTraveller["previousProcessStatus"] ==
                -2) {
              //current process has no output
              Fluttertoast.showToast(
                msg:
                    "The current process has no OUTPUT. Please ask the responsible person to complete BOM details!",
                timeInSecForIosWeb: 5,
              );
            } else if (responseOfGetProcessTraveller["previousProcessStatus"] ==
                -3) {
              //indicate that previous processs output is not enough to proceed to currenct station
              Fluttertoast.showToast(
                msg:
                    "Previous process ${responseOfGetProcessTraveller["previous_process_name"]} is still ON PROGRESS! Please wait until it is completed. Try again later!",
                timeInSecForIosWeb: 5,
              );
            } else if (responseOfGetProcessTraveller["previousProcessStatus"] ==
                2) {
              //print(responseOfGetProcessTraveller["processtraveller"]["id"]);
              //prvious process has completed
              checkWoTravellerProgress(
                  responseOfGetProcessTraveller["processtraveller"]["id"]
                      .toString());
              Fluttertoast.showToast(
                msg:
                    "SUCCESS! Work Order is successfully been registered to this terminal. You may start working.",
                timeInSecForIosWeb: 5,
              );
            }
          }
        } else {
          print(responseOfGetProcessTraveller["success"] == true);
          Fluttertoast.showToast(msg: "Invalid");
        }
      }
    } catch (e) {
      print(e);
    }
  }

  checkWoTravellerProgress(String wo_traveller_id) async {
    //final staffProvider = Provider.of<StaffProvider>(context, listen: false);
    try {
      var res = await http.post(
        Uri.parse(API.getWoProgressRecord),
        body: {
          'wo_process_traveller_id': wo_traveller_id,
          'staff_id': _currentUser!.staff_id.toString(),
          'station_id': widget.eachStation!.stationId.toString(),
        },
      );

      if (res.statusCode == 200) {
        var responseOfGetProcessTravellerPrgoressRecord = jsonDecode(res.body);
        if (responseOfGetProcessTravellerPrgoressRecord["success"] == true) {
          if (responseOfGetProcessTravellerPrgoressRecord["data"] == null) {
            Fluttertoast.showToast(
              msg:
                  "Previous process ${responseOfGetProcessTravellerPrgoressRecord["process_name"]} has NOT BEEN INITIALIZED yet! Please wait until it is completed. Try again later!",
              timeInSecForIosWeb: 5,
            );
          } else if (responseOfGetProcessTravellerPrgoressRecord["data"] == 0) {
            Fluttertoast.showToast(
              msg:
                  "Previous process ${responseOfGetProcessTravellerPrgoressRecord["process_name"]} is on INITIALIZATION! Please wait until it is completed. Try again later!",
              timeInSecForIosWeb: 5,
            );
          } else if (responseOfGetProcessTravellerPrgoressRecord["data"] == 1) {
            Fluttertoast.showToast(
              msg:
                  "Previous process ${responseOfGetProcessTravellerPrgoressRecord["process_name"]} is still ON PROGRESS! Please wait until it is completed. Try again later!",
              timeInSecForIosWeb: 5,
            );
          } else if (responseOfGetProcessTravellerPrgoressRecord[
                  "start_button_status"] ==
              0) {
            Fluttertoast.showToast(
              msg:
                  "Fail to start process. Please update pending quantity under REPLACEMENT QUANTITY! Click Pending Quantity button on the left and update the quantity in the table.",
              timeInSecForIosWeb: 5,
            );
          } else {
            Get.toNamed(
              "/detailsWo",
              arguments: widget.eachStation,
            );
            // Get.to(DetailsWorkOrder(
            //   wo: "refresh",
            // ));
            Fluttertoast.showToast(
              msg:
                  "SUCCESS! Work Order is successfully start to this terminal. You may start working.",
              timeInSecForIosWeb: 5,
            );
          }
        } else {
          print("swaeasd");
        }
      } else {
        print("sada");
      }
    } catch (e) {
      print("he ${_currentUser!.staff_id.toString()}");
      print(e);
    }
  }

  updateSkipAllProcess(String wo_id) async {
    try {
      //print(data);

      var res = await http.post(Uri.parse(API.getSkipAllProcess), body: {
        'staff_id': _currentUser!.staff_id.toString(),
        'wo_id': wo_id,
        'station_id': widget.eachStation!.stationId.toString(),
        'quantity': _textEditingController.quantity.value.toString(),
        'reason': _textEditingController.reason.value,
        'action': "skip_all_process",
      });

      if (res.statusCode == 200) {
        var responseOfSkipAllProcess = jsonDecode(res.body);
        if (responseOfSkipAllProcess['success'] == true) {
          Get.toNamed(
            "/detailsWo",
            arguments: widget.eachStation,
          );
          Fluttertoast.showToast(msg: "done");
        } else {
          print("ds");
        }
      } else {
        print("es");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserInfo();
  }

  @override
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                            context: context,
                            onCode: (code) async {
                              // Split the string by spaces and get the last part
                              List<String> parts = code!.split(' ');
                              String codeNew = parts.last;

// Convert the extracted part to an integer
                              //Stro? codeNumber = int.tryParse(codeNew);

                              print("WO scanned: $codeNew");
                              //staffProvider.fetchStaffInfo(codeNew);
                              fetchWoDetails(codeNew);
                            });
                      },
                      icon: Icon(Icons.qr_code),
                      label: Text(
                        'Scan WO',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                            context: context,
                            onCode: (code) async {
                              // Split the string by spaces and get the last part
                              List<String> parts = code!.split(' ');
                              String codeNew = parts.last;

                              // Convert the extracted part to an integer
                              //Stro? codeNumber = int.tryParse(codeNew);

                              print("WO scanned: $codeNew");
                              //staffProvider.fetchStaffInfo(codeNew);
                              Get.dialog(dialogAction(context, codeNew));
                            });
                      },
                      icon: Icon(Icons.qr_code),
                      label: Text(
                        'ByPass Process',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dialogAction(BuildContext context, String? wo_id) {
    return AlertDialog(
      title: Text("Process Skipping: WO: $wo_id"),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Set the size to min
          children: [
            Text("Are you want skip all process and current process?"),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: _textEditingController.skipProcessQuantity,
            ),
            Obx(() {
              return Text(
                _textEditingController.errorText.value,
                style: TextStyle(color: Colors.red),
              );
            }),
            //reason textfield
            TextFormField(
              controller: TextEditingController(
                  text: _textEditingController.reason.value),
              onChanged: _textEditingController.validateText,
              decoration: InputDecoration(
                labelText: "Reason",
                border: OutlineInputBorder(),
              ),
            ),
            Obx(
              () {
                if (_textEditingController.hasError.value) {
                  return Text(
                    'Field cannot be empty',
                    style: TextStyle(
                        color: Colors.red), // Customize the error message style
                  );
                } else {
                  return SizedBox
                      .shrink(); // An empty container when there's no error
                }
              },
            ),

            ElevatedButton(
              onPressed: () {
                if (_textEditingController.hasError.value) {
                  // Handle the error (e.g., display an error message)
                  print("Error: Field is empty");
                } else {
                  print("Entered Text: ${_textEditingController.reason.value}");
                  Get.back();
                  updateSkipAllProcess(wo_id!);
                }
                //print("Entered Text: ${_textEditingController.reason.value}");
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
