//import 'package:flutter/src/material/data_table.dart';
import 'package:flutter_web_1/models/employee.dart';

class WoProcessProgressAll {
  int? id;
  int? woProcessTravellerId;
  int? employeeId;
  int? stationId;
  DateTime? startDate;
  DateTime? endDate;
  String? quantity;
  String? extraQuantity;
  String? rejectedQuantityStatus;
  Employee? employee;

  WoProcessProgressAll({
    this.id,
    this.woProcessTravellerId,
    this.employeeId,
    this.stationId,
    this.startDate,
    this.endDate,
    this.quantity,
    this.extraQuantity,
    this.rejectedQuantityStatus,
    this.employee,
  });

  factory WoProcessProgressAll.fromJson(Map<String, dynamic> json) =>
      WoProcessProgressAll(
        id: json["id"],
        woProcessTravellerId: json["wo_process_traveller_id"],
        employeeId: json["employee_id"],
        stationId: json["station_id"],
        startDate: json["start_date"] != null
            ? DateTime.parse(json["start_date"])
            : null, // Handle null start_date
        endDate: json["end_date"] != null
            ? DateTime.parse(json["end_date"])
            : null, // Handle null end_date
        quantity:
            json["quantity"], // No need to check for null, allow it to be null
        extraQuantity: json[
            "extraQuantity"], // No need to check for null, allow it to be null
        rejectedQuantityStatus: json["rejectedQuantityStatus"],
        employee: json['employee'] != null
            ? Employee.fromJson(json['employee'])
            : null, // No need to check for null, allow it to be null
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "wo_process_traveller_id": woProcessTravellerId,
        "employee_id": employeeId,
        "station_id": stationId,
      };
}
