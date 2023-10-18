class Employee {
  int? id;
  String? fullName;

  Employee({
    this.id,
    this.fullName,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["id"],
        fullName: json["full_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
      };
}
