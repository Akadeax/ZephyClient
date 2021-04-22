class User {
  String sId;
  String fullName;
  String identifier;
  String password;

  User({this.sId, this.fullName, this.identifier, this.password});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
    identifier = json['identifier'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['fullName'] = this.fullName;
    data['identifier'] = this.identifier;
    data['password'] = this.password;
    return data;
  }
}