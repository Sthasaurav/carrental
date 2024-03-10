class Userlocation {
  String? latitude;
  String? longitude;

  Userlocation({
    this.latitude,
    this.longitude,
  });
  Userlocation.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;

    return data;
  }
}
