class Credential {
  String? name;
  String? address;
  String? email;
  String? phone;
  String? password;
  String? id;

  Credential(
      {this.name,
      this.address,
      this.email,
      this.phone,
      this.password,
      this.id});

  Credential.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['id'] = this.id;
    return data;
  }
}
