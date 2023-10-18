import 'package:flutter/material.dart';
import 'package:flutter_web_1/helpers/api_connection.dart';
import 'package:flutter_web_1/views/authentication/staffPreferences.dart';
import 'package:flutter_web_1/views/authentication/stationPreferences.dart';

class TestSecondScreen extends StatefulWidget {
  const TestSecondScreen({super.key});

  @override
  State<TestSecondScreen> createState() => _TestSecondScreenState();
}

class _TestSecondScreenState extends State<TestSecondScreen> {
  int? stationIpId;
  TextEditingController _textEditingController = TextEditingController();

  API apiConnection = API();

  Future<void> _loadIpId() async {
    final ip = await RememberStationPref.readIpInfo();
    if (ip != null) {
      setState(() {
        stationIpId = ip;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadIpId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _textEditingController,
            ),
            Text("IP: $stationIpId"),
            ElevatedButton(
              onPressed: () async {
                //await RememberUserPref.removeUserInfo();
                //await RememberStationPref.removeStationInfo();
                //apiConnection.setIp(_textEditingController.text);

                //print(apiConnection.getIp());
              },
              child: Text("Remove station User"),
            ),
          ],
        ),
      ),
    );
  }
}
