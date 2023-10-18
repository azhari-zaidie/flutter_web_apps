import 'package:flutter/material.dart';
import 'package:flutter_web_1/helpers/api_connection.dart';
import 'package:flutter_web_1/views/authentication/stationPreferences.dart';
import 'package:flutter_web_1/views/authentication/urlPreferences.dart';
import 'package:flutter_web_1/views/controller/formController.dart';
import 'package:flutter_web_1/views/testSecond.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;

class SelectStationScreen extends StatefulWidget {
  const SelectStationScreen({super.key});

  @override
  State<SelectStationScreen> createState() => _SelectStationScreenState();
}

class _SelectStationScreenState extends State<SelectStationScreen> {
  String? status = Get.arguments;
  final TextEditingController _numberController = TextEditingController();
  String _errorText = '';
  API apiConnection = API();
  final TextEditingController _urlController = TextEditingController();
  URL url = URL();
  String _ip = '';
  final MyFormController _textEditingController = Get.put(MyFormController());

  int _selectedIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (status == "done") {
      //html.window.location.reload();
      print("tes");
    }

    API.initialize().then((ip) {
      if (ip.isEmpty) {
        Fluttertoast.showToast(
          msg: "URL cant be empty",
          timeInSecForIosWeb: 10,
        );
        dialogURL(context);
      } else {
        Fluttertoast.showToast(
          msg: "URL: $ip",
          timeInSecForIosWeb: 10,
        );
      }
    });
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

                Text(_ip.isNotEmpty
                    ? "Select Station : URL $_ip"
                    : "Select Station"),
                SizedBox(
                  height: 10,
                ),
                //section section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter a number of Station ID',
                      errorText: _errorText,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        // Check if the entered text is a valid number
                        final input = _numberController.text;
                        final number = int.tryParse(input);

                        if (number == null) {
                          setState(() {
                            _errorText = 'Please enter a valid number.';
                          });
                        } else {
                          setState(() {
                            _errorText = '';
                          });
                          // Handle the valid number (e.g., submit it, perform an action, etc.)
                          // Here, you can add your logic to use the entered number.
                          print('Entered Number: $number');

                          await RememberStationPref.storeIpInfo(number);
                          //await url.setIp(_urlController.text);

                          String ip = await API.initialize();

                          if (ip.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "URL cant be empty",
                                timeInSecForIosWeb: 5);
                          } else {
                            Get.toNamed("/scanStaff");
                          }
                          //print(API.initialize());
                          //Get.toNamed("/scanStaff");
                          //sGet.to(TestSecondScreen());
                        }
                      },
                      child: Text('Submit'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        dialogURL(context);
                      },
                      child: Text('Change URL API'),
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

  @override
  void dispose() {
    // Dispose of the controller when it's no longer needed
    _numberController.dispose();
    super.dispose();
  }

  void dialogURL(BuildContext context) {
    String errorText = '';
    int quantity = 1; // Initial quantity value

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
              'Enter URL\nExample: http://192.168.22.2/intec-erp/public \nhttps://erp.inteceng.com.my'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: TextEditingController(
                    text: _textEditingController.text.value),
                onChanged: _textEditingController.validateText,
                decoration: InputDecoration(
                  labelText: "URL",
                  border: OutlineInputBorder(),
                ),
              ),
              Obx(
                () {
                  if (_textEditingController.hasError.value) {
                    return Text(
                      'Field cannot be empty',
                      style: TextStyle(
                          color:
                              Colors.red), // Customize the error message style
                    );
                  } else {
                    return SizedBox
                        .shrink(); // An empty container when there's no error
                  }
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_textEditingController.hasError.value) {
                    // Handle the error (e.g., display an error message)
                    print("Error: Field is empty");
                  } else {
                    print("Entered Text: ${_textEditingController.text.value}");
                    Get.back();
                    // Handle the button press here with the selected quantity
                    print(
                        'Selected Quantity: $_textEditingController.text.value');

                    Get.back();
                    setState(() {
                      status = "done";
                    });
                    await API.storeUrl(_textEditingController.text.value);
                    //_ip = await API.initialize();
                    html.window.location.reload();
                  }

                  //print(status);
                },
                child: Text("Submit"),
              ),
            ],
          ),
        );
      }, // Prevent closing on outside touch
    );
  }
}
