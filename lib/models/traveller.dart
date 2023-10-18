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
        wo_number: json["wo_number"],
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
