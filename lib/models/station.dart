class Station {
  String? name;
  int? stationId;
  int? employeeId;
  String? stationIpId;
  int? processId;
  int? locationId;
  int? userLevel;
  String? ipAdress;

  Station({
    this.name,
    this.stationId,
    this.employeeId,
    this.stationIpId,
    this.processId,
    this.locationId,
    this.userLevel,
    this.ipAdress,
  });

  factory Station.fromJson(Map<String, dynamic> json) => Station(
        name: json["name"],
        stationId: json["station_id"],
        employeeId: json["employee_id"],
        stationIpId: json["station_ip_id"],
        processId: json["process_id"],
        locationId: json["location_id"],
        userLevel: json["user_level"],
        ipAdress: json["ip_address"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "station_id": stationId,
        "employee_id": employeeId,
        "station_ip_id": stationIpId,
        "process_id": processId,
        "location_id": locationId,
        "user_level": userLevel,
        "ip_address": ipAdress,
      };
}
