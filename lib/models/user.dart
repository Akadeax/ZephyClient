class User {
  String sId;
  String fullName;
  String status;
  String identifier;
  String password;

  User({this.sId, this.fullName, this.identifier, this.password});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
    status = json['status'];
    identifier = json['identifier'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['fullName'] = this.fullName;
    data['status'] = this.status;
    data['identifier'] = this.identifier;
    data['password'] = this.password;
    return data;
  }
}

class ListedUser {
  static const int offline = 0;
  static const int online = 1;

  int onlineStatus;
  String sId;
  String fullName;
  String status;
  String identifier;

  ListedUser(
      {this.onlineStatus,
        this.sId,
        this.fullName,
        this.status,
        this.identifier});

  ListedUser.fromJson(Map<String, dynamic> json) {
    onlineStatus = json['onlineStatus'];
    sId = json['_id'];
    fullName = json['fullName'];
    status = json['status'];
    identifier = json['identifier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['onlineStatus'] = this.onlineStatus;
    data['_id'] = this.sId;
    data['fullName'] = this.fullName;
    data['status'] = this.status;
    data['identifier'] = this.identifier;
    return data;
  }
}