import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle the QR code button press here
                    //Get.toNamed("/scanWo", arguments: widget.eachStation);
                    //Get.to(ScannWOScreen(eachStation: widget.eachStation));
                  },
                  icon: Icon(Icons.qr_code),
                  label: Text(
                    'QR Code',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Center(
              child: Image.asset(
                'assets/images/intec_logo.png',
                fit: BoxFit.contain,
                height: 50,
              ),
            ),
            Spacer(),
            Text(
              "_currentUser!.fullName",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            //create
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Task List",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Get.to(CompletedScreen());
                  },
                  child: Text("History"),
                ),
              ],
            ),
            // Expanded(
            //   child: listOfProgressWO(context),
            // )
          ],
        ),
      ),
    );
  }
}
