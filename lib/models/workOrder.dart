import 'package:flutter_web_1/models/bom.dart';
import 'package:flutter_web_1/models/customer.dart';

class WorkOrder {
  int? id;
  int? prefixId;
  String? woNumber;
  String? joId;
  int? soItemId;
  DateTime? dueDate;
  String? bomId;
  int? customerId;
  String? quantity;
  int? partialQuantity;
  int? expediteQuantity;
  String? stockInBy;
  String? stockInDate;
  String? processTravellerRecheckedBy;
  String? processTravellerRecheckedDate;
  String? remark;
  String? mpsRemark;
  int? scheduleStatus;
  String? status;
  int? frameWoStatus;
  int? processState;
  int? inhouseBalance;
  Bom? bom;
  final Customer? customer;

  WorkOrder({
    this.id,
    this.prefixId,
    this.woNumber,
    this.joId,
    this.soItemId,
    this.dueDate,
    this.bomId,
    this.customerId,
    this.quantity,
    this.partialQuantity,
    this.expediteQuantity,
    this.stockInBy,
    this.stockInDate,
    this.processTravellerRecheckedBy,
    this.processTravellerRecheckedDate,
    this.remark,
    this.mpsRemark,
    this.scheduleStatus,
    this.status,
    this.frameWoStatus,
    this.processState,
    this.inhouseBalance,
    this.bom,
    this.customer,
  });

  factory WorkOrder.fromJson(Map<String, dynamic> json) => WorkOrder(
        id: json["id"],
        prefixId: json["prefix_id"],
        woNumber: json["wo_number"],
        joId: json["jo_id"],
        soItemId: json["so_item_id"],
        dueDate: DateTime.parse(json["due_date"]),
        bomId: json["bom_id"],
        customerId: json["customer_id"],
        quantity: json["quantity"],
        partialQuantity: json["partial_quantity"],
        expediteQuantity: json["expedite_quantity"],
        stockInBy: json["stock_in_by"],
        stockInDate: json["stock_in_date"],
        processTravellerRecheckedBy: json["process_traveller_rechecked_by"],
        processTravellerRecheckedDate: json["process_traveller_rechecked_date"],
        remark: json["remark"],
        mpsRemark: json["mps_remark"],
        scheduleStatus: json["schedule_status"],
        status: json["status"],
        frameWoStatus: json["frame_wo_status"],
        processState: json["process_state"],
        inhouseBalance: json["inhouse_balance"],
        bom: Bom.fromJson(json["bom"]),
        customer: json['customer'] != null
            ? Customer.fromJson(json['customer'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "prefix_id": prefixId,
        "wo_number": woNumber,
        "jo_id": joId,
        "so_item_id": soItemId,
        "due_date":
            "${dueDate!.year.toString().padLeft(4, '0')}-${dueDate!.month.toString().padLeft(2, '0')}-${dueDate!.day.toString().padLeft(2, '0')}",
        "bom_id": bomId,
        "customer_id": customerId,
        "quantity": quantity,
        "partial_quantity": partialQuantity,
        "expedite_quantity": expediteQuantity,
        "stock_in_by": stockInBy,
        "stock_in_date": stockInDate,
        "process_traveller_rechecked_by": processTravellerRecheckedBy,
        "process_traveller_rechecked_date": processTravellerRecheckedDate,
        "remark": remark,
        "mps_remark": mpsRemark,
        "schedule_status": scheduleStatus,
        "status": status,
        "frame_wo_status": frameWoStatus,
        "process_state": processState,
        "inhouse_balance": inhouseBalance,
        //"customer": customer!.toJson(),
      };
}
