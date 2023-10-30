import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_web_1/helpers/api_connection.dart';
import 'package:flutter_web_1/models/drawing.dart';
import 'package:flutter_web_1/models/staff.dart';
import 'package:flutter_web_1/models/station.dart';
import 'package:flutter_web_1/models/traveller.dart';
import 'package:flutter_web_1/views/authentication/staffPreferences.dart';
import 'package:flutter_web_1/views/completed_status.dart';
import 'package:flutter_web_1/views/controller/processController.dart';
import 'package:flutter_web_1/views/controller/quantityController.dart';
import 'package:flutter_web_1/views/customPagination.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:url_launcher/url_launcher.dart';

class DetailsWorkOrder extends StatefulWidget {
  final eachStation = Get.arguments as Station?;
  String? wo;
  //final Station? eachStation;
  DetailsWorkOrder({super.key, this.wo});
  @override
  State<DetailsWorkOrder> createState() => _DetailsWorkOrderState();
}

class _DetailsWorkOrderState extends State<DetailsWorkOrder> {
  int _selectedIndex = 0;
  TextEditingController qty = TextEditingController();
  String errorMessage = '';
  double finishedQty = 0;
  final controller = MyController();
  List<Processtraveller> allItems = [];
  int itemsPerPage = 5;
  int currentPage = 1;
  String done = '';
  int totalItems = 0;
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  String status = "on_progress";
  StaffClass? _currentUser;
  final url = 'http://192.168.22.2/intec-erp/public/api/traveller?wo_id=';
  TextEditingController _searchController = TextEditingController();
  //TextEditingController qty = TextEditingController();
  // final controller = MyControllerProcess();
  final MyControllerProcess _textEditingController =
      Get.put(MyControllerProcess());

  String searchQuery = ""; // Initialize this variable

  Future<void> _loadUserInfo() async {
    final user = await RememberUserPref.readUserInfo();
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  _launchURL(String wo_id) async {
    print("sds");
    if (await canLaunch(API.getTraveller + wo_id)) {
      await launch(API.getTraveller + wo_id);
    } else {
      throw 'Could not launch ${API.getTraveller + wo_id}';
    }
  }

  updateSkipCurrentProcess(String wo_id) async {
    try {
      //print(data);

      var res = await http.post(Uri.parse(API.getSkipAllProcess), body: {
        'staff_id': _currentUser!.staff_id.toString(),
        'wo_id': wo_id,
        'station_id': widget.eachStation!.stationId.toString(),
        'quantity': _textEditingController.quantity.value.toString(),
        'reason': _textEditingController.reason.value,
        'action': "skip_current_process",
      });

      if (res.statusCode == 200) {
        var responseOfSkipAllProcess = jsonDecode(res.body);
        if (responseOfSkipAllProcess['success'] == true) {
          Fluttertoast.showToast(
            msg: "Skip Current Process Complete",
            timeInSecForIosWeb: 5,
          );
          setState(() {
            done = "done";
          });
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

  //get work order traveller
  /*Future<List<Processtraveller>> getWorkOrderTraveller(String status) async {
    List<Processtraveller> getProcessTraveller = [];

    int startIndex = ((currentPage - 1) * itemsPerPage);
    int endIndex = startIndex + itemsPerPage;
    try {
      var res = await http.get(
          Uri.parse(
              "${API.getWoList}${widget.eachStation!.stationId}&status=$status"),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          });

      if (res.statusCode == 200) {
        var responseOfGetProcessTraveller = jsonDecode(res.body);
        if (responseOfGetProcessTraveller["success"] == true) {
          (responseOfGetProcessTraveller["work_order_process_traveller"]
                  as List)
              .forEach((element) {
            getProcessTraveller.add(Processtraveller.fromJson(element));
          });
          //print(responseOfGetProcessTraveller["work_order_process_traveller"].asmap)
          print(
              "${API.getWoList}${widget.eachStation!.stationId}&status=$status");

          if (endIndex > getProcessTraveller.length) {
            endIndex = getProcessTraveller.length;
          }

          if (endIndex > totalItems) {
            setState(() {
              totalItems = getProcessTraveller.length;
            });
          }

          return getProcessTraveller.sublist(startIndex, endIndex);
        } else {
          print("e");
        }
      } else {
        print(
            "${API.getWoList}${widget.eachStation!.stationId}&status=$status");
        print("object");
      }
    } catch (e) {
      print(e);
    }

    //print(getProcessTraveller);

    return [];
  }

  int getTotalPages() {
    print("sinis:: ${(totalItems / itemsPerPage).ceil()}");
    return (totalItems / itemsPerPage).ceil();
  }

  void clearPages(String status) {
    setState(() {
      currentPage = 1;
    });
  }
  
  */

  Future<List<Processtraveller>> getWorkOrderTraveller(int page) async {
    List<Processtraveller> getProcessTraveller = [];
    //String searchQuery = _searchController.text; // Get the search query
    try {
      var res;
      if (status == "SearchComplete" || status == "SearchOnProgress") {
        res = await http.get(
            Uri.parse(
                "${API.getWoList}${widget.eachStation!.stationId}&status=$status&keyword=${_searchController.text}"),
            headers: {
              'Content-type': 'application/json',
              'Accept': 'application/json',
            });
      } else {
        res = await http.get(
            Uri.parse(
                "${API.getWoList}${widget.eachStation!.stationId}&status=$status&page=$page"),
            headers: {
              'Content-type': 'application/json',
              'Accept': 'application/json',
            });
      }

      if (res.statusCode == 200) {
        var responseOfGetProcessTraveller = jsonDecode(res.body);
        if (responseOfGetProcessTraveller["success"] == true) {
          (responseOfGetProcessTraveller["work_order_process_traveller"]
                  as List)
              .forEach((element) {
            getProcessTraveller.add(Processtraveller.fromJson(element));
          });
          //print(responseOfGetProcessTraveller["work_order_process_traveller"].asmap)
          print(
              "${API.getWoList}${widget.eachStation!.stationId}&status=$status&page=$currentPage");
          // Filter the data based on the search query
          // if (searchQuery.isNotEmpty) {
          //   getProcessTraveller = getProcessTraveller.where((item) {
          //     return item.wo_number!.contains(searchQuery
          //         .toLowerCase()); // Adjust this condition to match your data structure
          //   }).toList();
          // }

          return getProcessTraveller;
        } else {
          print("e");
          print(
              "${API.getWoList}${widget.eachStation!.stationId}&status=$status&page=$currentPage");
        }
      } else {
        print(
            "${API.getWoList}${widget.eachStation!.stationId}&status=$status");
        print("object");
      }
    } catch (e) {
      print(
          "${API.getWoList}${widget.eachStation!.stationId}&status=$status&page=$currentPage");
    }

    //print(getProcessTraveller);

    return [];
  }

  progressQty(int quantity, int? id) async {
    //final staffProvider = Provider.of<StaffProvider>(context, listen: false);
    try {
      var res = await http.post(
        Uri.parse(API.updateQty),
        body: {
          'on_progress_id': id.toString(),
          'quantity': quantity.toString(),
          'station_id': widget.eachStation!.stationId.toString(),
          'employee_id': _currentUser!.staff_id.toString(),
        },
        headers: {
          'Accept': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        var responseOfUpdateQty = jsonDecode(res.body);
        if (responseOfUpdateQty['success'] == true) {
          if (responseOfUpdateQty['data'] == 0) {
            Fluttertoast.showToast(
              msg: "Input Qty more than Ordered Qty",
              timeInSecForIosWeb: 5,
            );
          } else {
            //listOfProgressWO(context);
            Fluttertoast.showToast(
              msg: "Quantity Updated",
              timeInSecForIosWeb: 5,
            );
            setState(() {
              done = "done";
            });

            //print("hsad: ${staffProvider.staffInfo!.staffId.toString()}");
          }
        } else {
          print("object");
        }
      } else {
        print("objects");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<ProcessTravellerProcess>> getGeneratedProcessTraveller(
      String? wo_id) async {
    List<ProcessTravellerProcess> process = [];
    //List<String> test = [];
    try {
      var res = await http.get(
        Uri.parse("${API.getTravellerProcess}$wo_id"),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        var responseOfDrawing = jsonDecode(res.body);
        if (responseOfDrawing['success'] == true) {
          (responseOfDrawing['processTravellers'] as List).forEach((element) {
            process.add(ProcessTravellerProcess.fromJson(element));
          });
          //print(bomProcessId);
        } else {
          print("drawing sana");
        }
      } else {
        print("drawing sini");
      }
    } catch (e) {
      print(e);
      print("drawing sini");
    }

    return process;
  }

  addProgressRecord(int id) async {
    //final staffProvider = Provider.of<StaffProvider>(context, listen: false);

    try {
      var res = await http.post(
        Uri.parse(API.addProgressRecord),
        body: {
          'employee_id': _currentUser!.staff_id.toString(),
          'station_id': widget.eachStation!.stationId.toString(),
          'wo_process_traveller_id': id.toString(),
        },
      );

      if (res.statusCode == 200) {
        var responseOfGetProcessTraveller = jsonDecode(res.body);
        if (responseOfGetProcessTraveller['success'] == true) {
          setState(() {
            done = "done";
          });
          Fluttertoast.showToast(
            msg: "Progress Record Added",
            timeInSecForIosWeb: 5,
          );
        } else {
          print("object");
        }
      } else {
        print("sd");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<Drawing>> getDrawing(int? bomProcessId) async {
    List<Drawing> drawing = [];
    //List<String> test = [];
    try {
      var res = await http.get(
        Uri.parse("${API.getDrawing}$bomProcessId"),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        var responseOfDrawing = jsonDecode(res.body);
        if (responseOfDrawing['success'] == true) {
          (responseOfDrawing['drawing'] as List).forEach((element) {
            drawing.add(Drawing.fromJson(element));
          });
          print(bomProcessId);
        } else {
          print("drawing sana");
        }
      } else {
        print("drawing sini");
      }
    } catch (e) {
      print(e);
      print("drawing sini");
    }

    return drawing;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.wo.toString());

    if (done == "done") {
      listOfProgressWO(context);
    }
    _loadUserInfo();
    API.initialize();
  }

  void clearPages() {
    setState(() {
      currentPage = 1;
    });
  }

  void downloadPDF(String pdfUrl, String filename) {
    // Create an anchor element for the download link
    final anchor = html.AnchorElement(href: pdfUrl)
      ..target = 'blank'
      ..download = filename
      ..click();
  }

  //Future<List<WO>> getListOfOnProgressWO() async{}
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
                    Get.toNamed("/scanProcess", arguments: widget.eachStation);
                    //Get.to(ScannWOScreen(eachStation: widget.eachStation));
                  },
                  icon: Icon(Icons.qr_code),
                  label: Text(
                    'Scan WO',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                // ElevatedButton.icon(
                //   onPressed: () {
                //     // Handle the QR code button press here
                //     Get.toNamed("/scanWoBypass", arguments: widget.eachStation);
                //     //Get.to(ScannWOScreen(eachStation: widget.eachStation));
                //   },
                //   icon: Icon(Icons.qr_code),
                //   label: Text(
                //     'ByPass Process',
                //     style: TextStyle(
                //       color: Colors.black,
                //     ),
                //   ),
                // ),
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
              _currentUser!.fullName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            //create
          ],
        ),
        leading: BackButton(
          onPressed: () {
            Get.toNamed("/listOfStation");
          },
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              widget.eachStation!.name!,
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
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search by WO NUMBER',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_selectedIndex == 0) {
                        setState(() {
                          status = "SearchOnProgress";
                        });
                      } else {
                        setState(() {
                          status = "SearchComplete";
                        });
                      }
                    },
                    child: Text("Search")),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 0;
                      status = "on_progress";
                    });

                    clearPages();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: _selectedIndex == 0
                        ? Colors.blue.shade300
                        : Colors.grey.shade100,
                  ),
                  child: Text(
                    'On Progress',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 1;
                      status = "Complete";
                    });
                    clearPages();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: _selectedIndex == 1
                        ? Colors.blue.shade300
                        : Colors.grey.shade100,
                  ),
                  child: Text(
                    'Complete',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                Spacer(),
                Text('Current Page: $currentPage'),
                SizedBox(width: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (currentPage > 1)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentPage--;
                            getWorkOrderTraveller(currentPage);
                          });
                        },
                        child: Text('Previous Page'),
                      ),
                    SizedBox(width: 16),
                    //if (currentPage < getTotalPages())
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentPage++;
                          getWorkOrderTraveller(currentPage);
                        });
                      },
                      child: Text('Next Page'),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: (_selectedIndex == 0)
                  ? listOfProgressWO(context)
                  : listOfCompleteWO(context),
            )
          ],
        ),
      ),
    );
  }

  Widget listOfProgressWO(context) {
    return FutureBuilder(
      future: getWorkOrderTraveller(currentPage),
      builder: (context, AsyncSnapshot<List<Processtraveller>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Connection Waiting...",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }

        if (dataSnapShot.data == null) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Finding the record...",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }

        if (dataSnapShot.data!.length > 0) {
          return SingleChildScrollView(
            child: ListView.builder(
              itemCount: dataSnapShot.data!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final eachProcessTraveller = dataSnapShot.data!;
                final workOrder = eachProcessTraveller[index].workOrder;
                final bom = workOrder!.bom;
                final customer = workOrder.customer;
                final woProcessProgressAll =
                    eachProcessTraveller[index].woProcessProgressAll;
                double totalQuantity = 0;
                double maxQty = 0;
                if (woProcessProgressAll.isNotEmpty) {
                  for (final feature in woProcessProgressAll) {
                    final quantity = feature.quantity;

                    if (quantity != null) {
                      double parsedQuantity = double.parse(quantity);

                      totalQuantity += parsedQuantity;
                      //print(parsedQuantity);
                    }

                    controller.finishedQty.value = totalQuantity;
                  }
                  maxQty = (double.parse(eachProcessTraveller[index]
                              .ioquantity
                              .toString()) *
                          double.parse(workOrder.quantity.toString())) -
                      totalQuantity;
                  print(totalQuantity);
                }

                controller.totalOrderQty.value = (double.parse(
                        eachProcessTraveller[index].ioquantity.toString()) *
                    double.parse(workOrder.quantity.toString()));

                // for (final feature in woProcessProgressAll!) {
                //   final quantity = feature.quantity;

                //   if (quantity != null) {
                //     double parsedQuantity = ;

                //     //totalQuantity += parsedQuantity;
                //     //print(parsedQuantity);

                //     setState(() {
                //       finishedQty += parsedQuantity;
                //     });
                //   }
                // }
                // Makro eachFamilyFound = dataSnapShot.data![index];
                return Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.fromLTRB(
                    16,
                    index == 0 ? 16 : 8,
                    16,
                    index == 5 - 1 ? 16 : 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade600,
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 5),
                      ),
                      BoxShadow(
                        color: Colors.grey.shade300,
                        offset: const Offset(-5, 0),
                      )
                    ],
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      //section 1
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FadeInImage(
                                    height: 100,
                                    width: 150,
                                    fit: BoxFit.fill,
                                    placeholder: const AssetImage(
                                        "assets/images/intec_logo.png"),
                                    //image: AssetImage("images/place_holder.png"),
                                    image: NetworkImage(
                                      'https://erp.inteceng.com.my/archieve/bom/${bom!.partNumber}/image/${bom!.image}',
                                    ),
                                  ),
                                  // bom!.image != null
                                  //     ? Image.network(
                                  //         'http://192.168.0.14/intec-erp/public/archieve/bom/0015-04622-03A8S/image/bom!.image',
                                  //         height: 100, // Set the desired height
                                  //         width: 100, // Set the desired width
                                  //       )
                                  //     : Image.asset(
                                  //         'assets/images/intec_logo.png',
                                  //         height: 100,
                                  //       ),

                                  const Text(
                                    "Remark",
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                  //remark from database
                                  Text(eachProcessTraveller[index]
                                      .id
                                      .toString()),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: "Part Number: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: bom.partNumber!,
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: "Customer Information: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: customer != null
                                              ? customer.name
                                              : 'N/A',
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: "Order Quantity: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text:
                                              "$totalQuantity/${double.parse(workOrder.quantity.toString()) * double.parse(eachProcessTraveller[index].ioquantity.toString())} ",
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text("Status: On Progress"),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    'Work Order :  ${workOrder.woNumber}',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Tooltip(
                                      message: 'Drawing',
                                      child: IconButton(
                                        onPressed: () {
                                          // Your onPressed function here
                                          Get.dialog(dialogAction(
                                              context,
                                              "Drawing",
                                              eachProcessTraveller[index]));
                                        },
                                        icon: Icon(Icons.analytics_outlined),
                                      ),
                                    ),
                                    Tooltip(
                                      message: 'Traveller',
                                      child: IconButton(
                                        onPressed: () {
                                          // Your onPressed function here
                                          print("test");
                                          _launchURL(eachProcessTraveller[index]
                                              .woId
                                              .toString());
                                        },
                                        icon: Icon(Icons.bookmark_add_outlined),
                                      ),
                                    ),
                                    Tooltip(
                                      message: 'Analytics',
                                      child: IconButton(
                                        onPressed: () {
                                          // Your onPressed function here
                                          Get.dialog(dialogProcess(
                                              context,
                                              "Generated Process Traveller",
                                              eachProcessTraveller[index]
                                                  .woId
                                                  .toString()));
                                        },
                                        icon: Icon(
                                            Icons.add_photo_alternate_outlined),
                                      ),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    //skip current process
                                    Get.dialog(dialogActionSkipProcess(
                                        context, eachProcessTraveller[index]));
                                  },
                                  child: Text("Skipp Process"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      //section 2
                      DataTable(
                        columns: const [
                          DataColumn(label: Text('#')),
                          DataColumn(label: Text('Start')),
                          DataColumn(label: Text('End')),
                          DataColumn(label: Text('Qty')),
                          DataColumn(label: Text('Operator')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: woProcessProgressAll
                            .asMap()
                            .entries
                            .map<DataRow>((items) {
                          final index = items.key + 1;
                          final item = items.value;

                          return DataRow(
                            cells: [
                              DataCell(Text(index.toString())),
                              DataCell(Text(item.startDate.toString())),
                              DataCell(Text(item.endDate.toString())),
                              DataCell(Text(item.quantity.toString())),
                              DataCell(
                                  Text(item.employee!.fullName.toString())),
                              DataCell(Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: (item.endDate == null)
                                        ? () {
                                            controller.maxQuantity.value =
                                                maxQty;
                                            Get.dialog(
                                              AlertDialog(
                                                title: Text(
                                                    'Enter Quantity: ID ${item.id}'),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onChanged: controller
                                                          .updateQuantity,
                                                    ),
                                                    Obx(() {
                                                      return Text(
                                                        controller
                                                            .errorText.value,
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      );
                                                    }),
                                                    Obx(
                                                      () => ElevatedButton(
                                                        onPressed: (controller
                                                                    .errorText
                                                                    .isEmpty &&
                                                                controller
                                                                        .quantity
                                                                        .value >
                                                                    0)
                                                            ? () async {
                                                                // Handle the button press here with the selected quantity
                                                                print(
                                                                    'Selected Quantity: ${controller.quantity.value}');

                                                                // //updatequantity in database
                                                                // progressQty(
                                                                //     controller
                                                                //         .quantity.value,
                                                                //     item.id);

                                                                var responseFromDialogBox =
                                                                    await showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return Dialog(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0), // Adjust the border radius as needed
                                                                      ),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      elevation:
                                                                          0.0,
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10.0), // Same border radius as above
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: <Widget>[
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(16.0),
                                                                              child: Text(
                                                                                "Submit Quantity",
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: 20.0,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
                                                                              child: Text(
                                                                                "Confirm Submit Quantity?",
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                  fontSize: 16.0,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    //updatequantity in database
                                                                                    progressQty(controller.quantity.value, item.id);

                                                                                    Get.back();
                                                                                  },
                                                                                  child: Text(
                                                                                    "Yes",
                                                                                    style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontSize: 18.0,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Text(
                                                                                    "No",
                                                                                    style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontSize: 18.0,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                );

                                                                // Close the dialog
                                                                Get.back();
                                                              }
                                                            : null, // Set onPressed to null when conditions are not met
                                                        child: Text('Submit'),
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        : null,
                                    child: Text('Edit Quantity'),
                                  ),
                                ],
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                      // DataTable(
                      //   columns: [
                      //     DataColumn(label: Text('#')),
                      //     DataColumn(label: Text('Start')),
                      //     DataColumn(label: Text('End')),
                      //     DataColumn(label: Text('Qty')),
                      //     DataColumn(label: Text('Operator')),
                      //     DataColumn(label: Text('Action')),
                      //   ],
                      //   rows: [
                      //     DataRow(
                      //       cells: [
                      //         DataCell(Text('1')),
                      //         DataCell(Text('2021-06-01 08:59:02')),
                      //         DataCell(Text('2021-06-01 08:59:02')),
                      //         DataCell(Text('3')),
                      //         DataCell(Text('Fatima Arifin Samsudin Bahri')),
                      //         DataCell(
                      //           ElevatedButton(
                      //             onPressed: () {
                      //               // Show the custom dialog when the button is pressed
                      //               showDialog(
                      //                 context: context,
                      //                 builder: (context) =>
                      //                     dialogQuantity(context, 0191),
                      //               );
                      //             },
                      //             child: Text('Edit Quantity'),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //     DataRow(
                      //       cells: [
                      //         DataCell(Text('2')),
                      //         DataCell(Text('2021-06-01 08:59:02')),
                      //         DataCell(Text('2021-06-01 08:59:02')),
                      //         DataCell(Text('4')),
                      //         DataCell(Text('Fatima Arifin Samsudin Bahri')),
                      //         DataCell(
                      //           ElevatedButton(
                      //             onPressed: () {
                      //               // Show the custom dialog when the button is pressed
                      //               showDialog(
                      //                 context: context,
                      //                 builder: (context) =>
                      //                     dialogQuantity(context, 0192),
                      //               );
                      //             },
                      //             child: Text('Edit Quantity'),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //     // Add more rows as needed
                      //   ],
                      // ),

                      SizedBox(
                        height: 10,
                      ),
                      //section 2
                      Obx(
                        () => ElevatedButton(
                            onPressed: (controller.finishedQty.value !=
                                    controller.totalOrderQty.value)
                                ? () async {
                                    var responseFromDialogBox =
                                        await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10.0), // Adjust the border radius as needed
                                          ),
                                          backgroundColor: Colors.transparent,
                                          elevation: 0.0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(
                                                  10.0), // Same border radius as above
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Image.asset(
                                                  'assets/images/packaging.gif',
                                                  width:
                                                      100.0, // Adjust the width as needed
                                                  height:
                                                      100.0, // Adjust the height as needed
                                                ),
                                                const Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Text(
                                                    "Submit Quantity",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                ),
                                                const Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0,
                                                          right: 16.0,
                                                          bottom: 24.0),
                                                  child: Text(
                                                    "Add new Operation Record?",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        //add new progress record
                                                        addProgressRecord(
                                                            eachProcessTraveller[
                                                                    index]
                                                                .id);

                                                        Get.back();
                                                        // Navigator.pop(context,
                                                        //     "YesContinue");
                                                      },
                                                      child: const Text(
                                                        "Yes",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18.0,
                                                        ),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        "No",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                : null,
                            child: Text("Add Progress Record")),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(
            child: Text("Empty, no data"),
          );
        }
      },
    );
  }

  Widget listOfCompleteWO(context) {
    return FutureBuilder(
      future: getWorkOrderTraveller(currentPage),
      builder: (context, AsyncSnapshot<List<Processtraveller>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Connection Waiting...",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }

        if (dataSnapShot.data == null) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Finding the record...",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }

        if (dataSnapShot.data!.length > 0) {
          return SingleChildScrollView(
            child: ListView.builder(
              itemCount: dataSnapShot.data!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final eachProcessTraveller = dataSnapShot.data!;
                final workOrder = eachProcessTraveller[index].workOrder;
                final bom = workOrder!.bom;
                final customer = workOrder.customer;
                final woProcessProgressAll =
                    eachProcessTraveller[index].woProcessProgressAll;
                double totalQuantity = 0;
                double maxQty = 0;
                if (woProcessProgressAll.isNotEmpty) {
                  for (final feature in woProcessProgressAll) {
                    final quantity = feature.quantity;

                    if (quantity != null) {
                      double parsedQuantity = double.parse(quantity);

                      totalQuantity += parsedQuantity;
                      //print(parsedQuantity);
                    }

                    controller.finishedQty.value = totalQuantity;
                  }
                  maxQty = (double.parse(eachProcessTraveller[index]
                              .ioquantity
                              .toString()) *
                          double.parse(workOrder.quantity.toString())) -
                      totalQuantity;
                  print(totalQuantity);
                }

                controller.totalOrderQty.value = (double.parse(
                        eachProcessTraveller[index].ioquantity.toString()) *
                    double.parse(workOrder.quantity.toString()));

                // for (final feature in woProcessProgressAll!) {
                //   final quantity = feature.quantity;

                //   if (quantity != null) {
                //     double parsedQuantity = ;

                //     //totalQuantity += parsedQuantity;
                //     //print(parsedQuantity);

                //     setState(() {
                //       finishedQty += parsedQuantity;
                //     });
                //   }
                // }
                // Makro eachFamilyFound = dataSnapShot.data![index];
                return Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.fromLTRB(
                    16,
                    index == 0 ? 16 : 8,
                    16,
                    index == 5 - 1 ? 16 : 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade600,
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 5),
                      ),
                      BoxShadow(
                        color: Colors.grey.shade300,
                        offset: const Offset(-5, 0),
                      )
                    ],
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      //section 1
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FadeInImage(
                                    height: 100,
                                    width: 150,
                                    fit: BoxFit.fill,
                                    placeholder: const AssetImage(
                                        "assets/images/intec_logo.png"),
                                    //image: AssetImage("images/place_holder.png"),
                                    image: NetworkImage(
                                      'https://erp.inteceng.com.my/archieve/bom/${bom!.partNumber}/image/${bom!.image}',
                                    ),
                                  ),
                                  // bom!.image != null
                                  //     ? Image.network(
                                  //         'http://192.168.0.14/intec-erp/public/archieve/bom/0015-04622-03A8S/image/bom!.image',
                                  //         height: 100, // Set the desired height
                                  //         width: 100, // Set the desired width
                                  //       )
                                  //     : Image.asset(
                                  //         'assets/images/intec_logo.png',
                                  //         height: 100,
                                  //       ),

                                  const Text(
                                    "Remark",
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                  //remark from database
                                  Text(eachProcessTraveller[index]
                                      .id
                                      .toString()),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: "Part Number: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: bom.partNumber!,
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: "Customer Information: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: customer != null
                                              ? customer.name
                                              : 'N/A',
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: "Order Quantity: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text:
                                              "$totalQuantity/${double.parse(workOrder.quantity.toString()) * double.parse(eachProcessTraveller[index].ioquantity.toString())} ",
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text("Status: Complete"),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    'Work Order :  ${workOrder.woNumber}',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Tooltip(
                                      message: 'Drawing',
                                      child: IconButton(
                                        onPressed: () {
                                          // Your onPressed function here
                                          Get.dialog(dialogAction(
                                              context,
                                              "Drawing",
                                              eachProcessTraveller[index]));
                                        },
                                        icon: Icon(Icons.analytics_outlined),
                                      ),
                                    ),
                                    Tooltip(
                                      message: 'Traveller',
                                      child: IconButton(
                                        onPressed: () {
                                          // Your onPressed function here
                                          _launchURL(eachProcessTraveller[index]
                                              .woId
                                              .toString());
                                        },
                                        icon: Icon(Icons.bookmark_add_outlined),
                                      ),
                                    ),
                                    Tooltip(
                                      message: 'Analytics',
                                      child: IconButton(
                                        onPressed: () {
                                          // Your onPressed function here
                                          Get.dialog(dialogProcess(
                                              context,
                                              "Generated Process Traveller",
                                              eachProcessTraveller[index]
                                                  .woId
                                                  .toString()));
                                        },
                                        icon: Icon(
                                            Icons.add_photo_alternate_outlined),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      //section 2
                      DataTable(
                        columns: const [
                          DataColumn(label: Text('#')),
                          DataColumn(label: Text('Start')),
                          DataColumn(label: Text('End')),
                          DataColumn(label: Text('Qty')),
                          DataColumn(label: Text('Operator')),
                        ],
                        rows: woProcessProgressAll
                            .asMap()
                            .entries
                            .map<DataRow>((items) {
                          final index = items.key + 1;
                          final item = items.value;

                          return DataRow(
                            cells: [
                              DataCell(Text(index.toString())),
                              DataCell(Text(item.startDate.toString())),
                              DataCell(Text(item.endDate.toString())),
                              DataCell(Text(item.quantity.toString())),
                              DataCell(
                                  Text(item.employee!.fullName.toString())),
                            ],
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(
            child: Text("Empty, no data"),
          );
        }
      },
    );
  }

  Widget dialogAction(
      BuildContext context, String action, Processtraveller? processtraveller) {
    return AlertDialog(
      title: Text(action),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        child: FutureBuilder(
          future: getDrawing(processtraveller!.bomProcessId),
          builder: (context, AsyncSnapshot<List<Drawing>> dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Connection Waiting...",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            }
            if (dataSnapShot.data == null) {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Finding the record...",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            }

            if (dataSnapShot.data!.length > 0) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: dataSnapShot.data!.length,
                itemBuilder: (context, index) {
                  Drawing eachDrawing = dataSnapShot.data![index];
                  return Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.fromLTRB(
                      16,
                      index == 0 ? 16 : 8,
                      16,
                      index == 5 - 1 ? 16 : 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      border: Border.all(
                        color: Colors.grey, // Adjust the border color
                        width: 1.0, // Adjust the border width
                      ),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        (eachDrawing.extension! == 'jpg')
                            ? 'assets/library/024-jpg.png'
                            : (eachDrawing.extension! == 'png')
                                ? 'assets/library/015-png.png'
                                : (eachDrawing.extension! == 'gif')
                                    ? 'assets/library/031-gif.png'
                                    : (eachDrawing.extension! == 'docx')
                                        ? 'assets/library/038-doc.png'
                                        : (eachDrawing.extension! == 'pdf')
                                            ? 'assets/library/017-pdf.png'
                                            : (eachDrawing.extension! == 'csv')
                                                ? 'assets/library/052-csv.png'
                                                : (eachDrawing.extension! ==
                                                        'pptx')
                                                    ? 'assets/library/014-ppt.png'
                                                    : (eachDrawing.extension! ==
                                                            'dwg')
                                                        ? 'assets/library/035-dwg..png'
                                                        : (eachDrawing
                                                                    .extension! ==
                                                                'stp')
                                                            ? 'assets/library/051-stp.png'
                                                            : 'assets/library/white.png',
                        height: 100,
                        width: 100,
                      ), // Replace with your image widget
                      title: Text(eachDrawing.name!),
                      subtitle: Text("${eachDrawing.extension} File"),
                      trailing: Tooltip(
                        message: 'Download',
                        child: IconButton(
                          onPressed: () {
                            //print("https://erp.inteceng.com.my/${eachDrawing.url!}");
                            // Your onPressed function here
                            final pdfUrl = API.getDownloadFile +
                                eachDrawing.url!; // Replace with your PDF URL
                            downloadPDF(pdfUrl, eachDrawing.filename!);
                          },
                          icon: Icon(Icons.download_outlined),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("Empty, no data."),
              );
            }
          },
        ),
      ),
    );
  }

  Widget dialogProcess(BuildContext context, String action, String wo_id) {
    return AlertDialog(
      title: Text(action),
      content: Container(
        width: MediaQuery.of(context).size.width * 1,
        child: FutureBuilder(
          future: getGeneratedProcessTraveller(wo_id),
          builder: (context,
              AsyncSnapshot<List<ProcessTravellerProcess>> dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Connection Waiting...",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              );
            }
            if (dataSnapShot.data == null) {
              return const Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Finding the record...",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              );
            }

            if (dataSnapShot.data!.isNotEmpty) {
              return SingleChildScrollView(
                child: DataTable(
                  border: const TableBorder(
                    top: BorderSide(color: Colors.grey, width: 0.5),
                    bottom: BorderSide(color: Colors.grey, width: 0.5),
                    left: BorderSide(color: Colors.grey, width: 0.5),
                    right: BorderSide(color: Colors.grey, width: 0.5),
                    horizontalInside:
                        BorderSide(color: Colors.grey, width: 0.5),
                    verticalInside: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                  columns: const [
                    DataColumn(
                      label: Expanded(
                          child: Center(
                              child: Text(
                        '#',
                        textAlign: TextAlign.center,
                      ))),
                    ),
                    DataColumn(
                      label: Expanded(
                          child: Center(
                              child: Text(
                        'Process Name',
                        textAlign: TextAlign.center,
                      ))),
                    ),
                    DataColumn(
                      label: Expanded(
                          child: Center(
                              child: Text(
                        'Finished Qty',
                        textAlign: TextAlign.center,
                      ))),
                    ),
                    DataColumn(
                      label: Expanded(
                          child: Center(
                              child: Text(
                        'Remark',
                        textAlign: TextAlign.center,
                      ))),
                    ),
                    DataColumn(
                      label: Expanded(
                          child: Center(
                              child: Text(
                        'Status',
                        textAlign: TextAlign.center,
                      ))),
                    ),
                    DataColumn(
                      label: Expanded(
                          child: Center(
                              child: Text(
                        'Location',
                        textAlign: TextAlign.center,
                      ))),
                    ),
                    DataColumn(
                      label: Expanded(
                          child: Center(
                              child: Text(
                        'Sequence',
                        textAlign: TextAlign.center,
                      ))),
                    ),
                  ],
                  rows:
                      dataSnapShot.data!.asMap().entries.map<DataRow>((entry) {
                    final index = entry.key + 1;
                    final eachProcess = entry.value;
                    var remark;
                    int changeRemark = 0;
                    if (eachProcess.rejectedQuantity == "-") {
                      if (eachProcess.remark != "Repacking") {
                        remark = eachProcess.remark.toString();
                        changeRemark = 0;
                      } else {
                        changeRemark = 1;
                        remark = RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Skipped process by ',
                                style: TextStyle(color: Colors.red),
                              ),
                              TextSpan(
                                text: eachProcess.skippedBy,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: ' on ',
                                style: TextStyle(color: Colors.red),
                              ),
                              TextSpan(
                                text: eachProcess.skippedOn,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "\nReason: ${eachProcess.remark}",
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      if (eachProcess.remark == "-") {
                        changeRemark = 0;
                        remark =
                            "${eachProcess.rejectedQuantity} Not received from Previous Process";
                      } else {
                        changeRemark = 0;
                        remark =
                            "${eachProcess.rejectedQuantity} ${eachProcess.remark} in ${eachProcess.rejectedProcessName}";
                      }
                    }
                    return DataRow(
                      cells: [
                        DataCell(
                          Expanded(
                              child: Center(
                                  child: Text(
                            index.toString(),
                            textAlign: TextAlign.center,
                          ))),
                        ),
                        DataCell(Text(
                          eachProcess.processName!,
                          maxLines: 2,
                        )),
                        DataCell(
                          Expanded(
                              child: Center(
                                  child: Text(
                            "${eachProcess.finishedQuantity!.toString()}/${eachProcess.orderQuantity!.toString()} ",
                            textAlign: TextAlign.center,
                          ))),
                        ),
                        DataCell((changeRemark == 0)
                            ? Text(
                                remark,
                                maxLines: 2,
                              )
                            : remark),
                        DataCell(
                          Expanded(
                              child: Center(
                                  child: button(
                                      BuildContext, eachProcess.status!))),
                        ),
                        DataCell(Text(
                          eachProcess.location!,
                          maxLines: 2,
                        )),
                        DataCell(
                          Expanded(
                              child: Center(
                                  child: Text(
                            eachProcess.sequence!.toString(),
                            textAlign: TextAlign.center,
                          ))),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              );
            } else {
              return Center(
                child: Text("Empty, no data"),
              );
            }
          },
        ),
      ),
    );
  }

  Widget button(BuildContext, int i) {
    return (i == 0)
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue, // Set the text color to white
              padding: const EdgeInsets.symmetric(
                  horizontal: 16), // Adjust padding as needed
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    4), // Adjust the border radius as needed
              ),
            ),
            onPressed: () {
              // Add your onPressed callback here
            },
            child: const Text(
              "Initialized",
              style: TextStyle(fontSize: 14), // Adjust the font size as needed
            ),
          )
        : (i == 1)
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.yellow, // Set the text color to white
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16), // Adjust padding as needed
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        4), // Adjust the border radius as needed
                  ),
                ),
                onPressed: () {
                  // Add your onPressed callback here
                },
                child: const Text(
                  "On Progress",
                  style:
                      TextStyle(fontSize: 14), // Adjust the font size as needed
                ),
              )
            : (i == 2)
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          Colors.green, // Set the text color to white
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16), // Adjust padding as needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            4), // Adjust the border radius as needed
                      ),
                    ),
                    onPressed: () {
                      // Add your onPressed callback here
                    },
                    child: const Text(
                      "Complete",
                      style: TextStyle(
                          fontSize: 14), // Adjust the font size as needed
                    ),
                  )
                : (i == 3)
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              Colors.yellow, // Set the text color to white
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16), // Adjust padding as needed
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                4), // Adjust the border radius as needed
                          ),
                        ),
                        onPressed: () {
                          // Add your onPressed callback here
                        },
                        child: const Text(
                          "Extra Quantity",
                          style: TextStyle(
                              fontSize: 14), // Adjust the font size as needed
                        ),
                      )
                    : (i == 4)
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  Colors.yellow, // Set the text color to white
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16), // Adjust padding as needed
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    4), // Adjust the border radius as needed
                              ),
                            ),
                            onPressed: () {
                              // Add your onPressed callback here
                            },
                            child: const Text(
                              "Partial",
                              style: TextStyle(
                                  fontSize:
                                      14), // Adjust the font size as needed
                            ),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  Colors.red, // Set the text color to white
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16), // Adjust padding as needed
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    4), // Adjust the border radius as needed
                              ),
                            ),
                            onPressed: () {
                              // Add your onPressed callback here
                            },
                            child: const Text(
                              "Unintialized",
                              style: TextStyle(
                                  fontSize:
                                      14), // Adjust the font size as needed
                            ),
                          );
  }

  Widget dialogQuantity(BuildContext context, int id) {
    String errorText = '';
    int quantity = 1; // Initial quantity value

    return AlertDialog(
      title: Text('Enter Quantity: ID $id'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (quantity.toString().isNotEmpty) {
                if (quantity > 10) {
                  setState(() {});
                  // Close the dialog
                  errorText = 'ret';
                } else {
                  Navigator.of(context).pop();
                }
              }

              print('te $errorText');
              // Handle the button press here with the selected quantity
              print('Selected Quantity: $quantity');
            },
            child: Text('Submit'),
          ),
          if (errorText.isNotEmpty)
            Text(
              errorText,
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  Widget dialogActionSkipProcess(
      BuildContext context, Processtraveller traveller) {
    return AlertDialog(
      title: Text("Process Skipping"),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Set the size to min
          children: [
            Text("Are you want skip current process?"),
            Text("Quantity: ${traveller.workOrder!.quantity.toString()}"),
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

            SizedBox(
              height: 10,
            ),

            Obx(() {
              return ElevatedButton(
                onPressed: _textEditingController.hasError.value ||
                        _textEditingController.errorText.value.isNotEmpty
                    ? null
                    : () {
                        print(
                            "Entered Text: ${_textEditingController.reason.value}");
                        Get.back();
                        updateSkipCurrentProcess(traveller.woId!.toString());
                        // Handle your logic here
                      },
                child: Text("Submit"),
              );
            }),
          ],
        ),
      ),
    );
  }
}
