class Bom {
  int? id;
  int? bomTypeId;
  int? projectId;
  String? partNumber;
  String? partNumber2;
  String? partName;
  String? tarifCode;
  String? bracketCode;
  String? material;
  String? masterPartNumber;
  int? quantity;
  String? revision;
  String? status;
  String? customerId;
  String? uomId;
  String? image;
  int? engineeringBom;
  String? finishing;

  Bom({
    this.id,
    this.bomTypeId,
    this.projectId,
    this.partNumber,
    this.partNumber2,
    this.partName,
    this.tarifCode,
    this.bracketCode,
    this.material,
    this.masterPartNumber,
    this.quantity,
    this.revision,
    this.status,
    this.customerId,
    this.uomId,
    this.image,
    this.engineeringBom,
    this.finishing,
  });

  factory Bom.fromJson(Map<String, dynamic> json) => Bom(
        id: json["id"],
        bomTypeId: json["bom_type_id"],
        projectId: json["project_id"],
        partNumber: json["part_number"],
        partNumber2: json["part_number2"],
        partName: json["part_name"],
        tarifCode: json["tarif_code"],
        bracketCode: json["bracket_code"],
        material: json["material"],
        masterPartNumber: json["master_part_number"],
        quantity: json["quantity"],
        revision: json["revision"],
        status: json["status"],
        customerId: json["customer_id"],
        uomId: json["uom_id"],
        image: json["image"],
        engineeringBom: json["engineering_bom"],
        finishing: json["finishing"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bom_type_id": bomTypeId,
        "project_id": projectId,
        "part_number": partNumber,
        "part_number2": partNumber2,
        "part_name": partName,
        "tarif_code": tarifCode,
        "bracket_code": bracketCode,
        "material": material,
        "master_part_number": masterPartNumber,
        "quantity": quantity,
        "revision": revision,
        "status": status,
        "customer_id": customerId,
        "uom_id": uomId,
        "image": image,
        "engineering_bom": engineeringBom,
        "finishing": finishing,
      };
}
