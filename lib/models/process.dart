class Process {
  int? id;
  int? departmentId;
  String? name;
  String? description;
  String? remark;

  Process({
    this.id,
    this.departmentId,
    this.name,
    this.description,
    this.remark,
  });

  factory Process.fromJson(Map<String, dynamic> json) => Process(
        id: json["id"],
        departmentId: json["department_id"],
        name: json["name"],
        description: json["description"],
        remark: json["remark"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "department_id": departmentId,
        "name": name,
        "description": description,
        "remark": remark,
      };
}
