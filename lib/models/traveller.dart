import 'package:flutter_web_1/models/workOrder.dart';
import 'package:flutter_web_1/models/workOrderProgressRecord.dart';

class Processtraveller {
  int id;
  int? woId;
  dynamic productionDate;
  int? bomProcessId;
  int? processId;
  int? sequence;
  dynamic rejectedQuantity;
  dynamic partialQuantity;
  dynamic rejectedProcessId;
  dynamic remark;
  dynamic woOperationScheduleId;
  dynamic itemReceivalStatus;
  int? itemTransferStatus;
  int? status;
  String? ioquantity;
  String? wo_number;
  String? process_name;
  String? rejected_process_name;
  String? finished_quantity;
  String? skipped_by;
  String? skipped_on;
  String? location;
  WorkOrder? workOrder;
  List<WoProcessProgressAll> woProcessProgressAll;

  Processtraveller({
    required this.id,
    this.woId,
    this.productionDate,
    this.bomProcessId,
    this.processId,
    this.sequence,
    this.rejectedQuantity,
    this.partialQuantity,
    this.rejectedProcessId,
    this.remark,
    this.woOperationScheduleId,
    this.itemReceivalStatus,
    this.itemTransferStatus,
    this.status,
    this.workOrder,
    required this.woProcessProgressAll,
    this.ioquantity,
    this.wo_number,
    this.finished_quantity,
    this.location,
    this.process_name,
    this.rejected_process_name,
    this.skipped_by,
    this.skipped_on,
  });

  factory Processtraveller.fromJson(Map<String, dynamic> json) =>
      Processtraveller(
        id: json["id"],
        woId: json["wo_id"],
        productionDate: json["production_date"],
        bomProcessId: json["bom_process_id"],
        processId: json["process_id"],
        sequence: json["sequence"],
        rejectedQuantity: json["rejected_quantity"],
        partialQuantity: json["partial_quantity"],
        rejectedProcessId: json["rejected_process_id"],
        remark: json["remark"],
        woOperationScheduleId: json["wo_operation_schedule_id"],
        itemReceivalStatus: json["item_receival_status"],
        itemTransferStatus: json["item_transfer_status"],
        status: json["status"],
        workOrder: WorkOrder.fromJson(json["work_order"]),
        woProcessProgressAll: (json["wo_process_progress_all"] as List<dynamic>)
            .map((featureJson) => WoProcessProgressAll.fromJson(featureJson))
            .toList(),
        ioquantity: json["ioquantity"],
        finished_quantity: json["finished_quantity"],
        location: json["location"],
        process_name: json["process_name"],
        wo_number: json["wo_number"],
        rejected_process_name: json["rejected_process_name"],
        skipped_by: json["skipped_by"],
        skipped_on: json["skipped_on"],
        // woProcessProgressAll: json["wo_process_progress_all"] != null
        //     ? List<WoProcessProgressAll>.from(json["wo_process_progress_all"]
        //         .map((x) => WoProcessProgressAll.fromJson(x)))
        //     : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "wo_id": woId,
        "production_date": productionDate,
        "bom_process_id": bomProcessId,
        "process_id": processId,
        "sequence": sequence,
        "rejected_quantity": rejectedQuantity,
        "partial_quantity": partialQuantity,
        "rejected_process_id": rejectedProcessId,
        "remark": remark,
        "wo_operation_schedule_id": woOperationScheduleId,
        "item_receival_status": itemReceivalStatus,
        "item_transfer_status": itemTransferStatus,
        "status": status,
        "work_order": workOrder!.toJson(),
      };
}

class ProcessTravellerProcess {
  int? sequence;
  String? rejectedQuantity;
  String? remark;
  int? status;
  String? processName;
  String? rejectedProcessName;
  int? orderQuantity;
  int? finishedQuantity;
  String? skippedBy;
  String? skippedOn;
  String? location;

  ProcessTravellerProcess({
    this.sequence,
    this.rejectedQuantity,
    this.remark,
    this.status,
    this.processName,
    this.rejectedProcessName,
    this.orderQuantity,
    this.finishedQuantity,
    this.skippedBy,
    this.skippedOn,
    this.location,
  });

  factory ProcessTravellerProcess.fromJson(Map<String, dynamic> json) =>
      ProcessTravellerProcess(
        sequence: json["sequence"],
        rejectedQuantity: json["rejected_quantity"] ?? "-",
        remark: json["remark"] ?? "-",
        status: json["status"] ?? 5,
        processName: json["process_name"] ?? "-",
        orderQuantity: json["order_quantity"],
        rejectedProcessName: json["rejectedProcessName"],
        finishedQuantity: json["finished_quantity"] ?? 0,
        skippedBy: json["skipped_by"] ?? "Relation Lost",
        skippedOn: json["skipped_on"] ?? "Relation Lost",
        location: json["location"] ?? "Relation Lost",
      );
}
