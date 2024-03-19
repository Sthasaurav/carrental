class Users {
  String? displayName;
  String? email;
  String? photoURL;
  String? phone;

  Users({this.displayName, this.email, this.photoURL, this.phone});
  Users.fromJson(Map<String, dynamic> json) {
    displayName = json['displayName'];
    email = json['email'];
    photoURL = json['photoURl'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayName'] = this.displayName;
    data['email'] = this.email;
    data['photoURL'] = this.photoURL;
    data['phone'] = this.phone;
    return data;
  }
}
