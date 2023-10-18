import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_web_1/helpers/api_connection.dart';
import 'package:flutter_web_1/models/staff.dart';
import 'package:flutter_web_1/models/station.dart';
import 'package:flutter_web_1/views/authentication/staffPreferences.dart';
import 'package:flutter_web_1/views/controller/processController.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

class ByPassProcessScreen extends StatefulWidget {
  final eachStation = Get.arguments as Station?;
  ByPassProcessScreen({super.key});

  @override
  State<ByPassProcessScreen> createState() => _ByPassProcessScreenState();
}

class _ByPassProcessScreenState extends State<ByPassProcessScreen> {
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();

  final GlobalKey _qrKey = GlobalKey();
  QRViewController? _controller;

// Calculate the desired aspect ratio (e.g., 1:1)
  double aspectRatio = 1.0;
  StaffClass? _currentUser;
  String? code;
  //TextEditingController _textEditingController = TextEditingController();
  TextEditingController qty = TextEditingController();
  // final controller = MyControllerProcess();
  final MyControllerProcess _textEditingController =
      Get.put(MyControllerProcess());

  Future<void> _loadUserInfo() async {
    final user = await RememberUserPref.readUserInfo();
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/card_1.jpg'), // Replace with your image asset path
            fit: BoxFit
                .cover, // Adjust this as needed to cover or contain the image
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
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
                  child: Text("Click me")),
              SizedBox(height: 20),
              Text(
                'Scan the Work Order QR code above:',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dialogAction(BuildContext context, String? wo_id) {
    return AlertDialog(
      title: Text("Process Skipping"),
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
