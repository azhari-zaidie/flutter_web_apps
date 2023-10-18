class StaffClass {
  int id;
  int userId;
  String fullName;
  String staff_id;

  StaffClass(
    this.id,
    this.userId,
    this.fullName,
    this.staff_id,
  );

  factory StaffClass.fromJson(Map<String, dynamic> json) => StaffClass(
        json["id"],
        json["user_id"],
        json["full_name"],
        json["staff_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "full_name": fullName,
        "staff_id": staff_id,
      };
}
