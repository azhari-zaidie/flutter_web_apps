class Customer {
  int? id;
  String? name;
  String? coRegNo;
  String? sstRegNo;
  String? address1;
  String? address2;
  String? address3;
  String? country;
  String? phone;
  String? fax;
  String? email;
  String? description;

  Customer({
    this.id,
    this.name,
    this.coRegNo,
    this.sstRegNo,
    this.address1,
    this.address2,
    this.address3,
    this.country,
    this.phone,
    this.fax,
    this.email,
    this.description,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        name: json["name"],
        coRegNo: json["co_reg_no"],
        sstRegNo: json["sst_reg_no"],
        address1: json["address_1"],
        address2: json["address_2"],
        address3: json["address_3"],
        country: json["country"],
        phone: json["phone"],
        fax: json["fax"],
        email: json["email"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "co_reg_no": coRegNo,
        "sst_reg_no": sstRegNo,
        "address_1": address1,
        "address_2": address2,
        "address_3": address3,
        "country": country,
        "phone": phone,
        "fax": fax,
        "email": email,
        "description": description,
      };
}
