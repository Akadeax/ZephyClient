import 'package:zephy_client/models/role_model.dart';

class User {
  List<String> roles;
  String sId;
  String name;
  String email;
  String password;

  User({this.roles, this.sId, this.name, this.email, this.password});

  User.fromJson(Map<String, dynamic> json) {
    roles = json['roles'].cast<String>();
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roles'] = this.roles;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}

class PopulatedUser {
  List<Role> roles;
  String sId;
  String name;
  String email;
  String password;

  PopulatedUser({this.roles, this.sId, this.name, this.email, this.password});

  PopulatedUser.fromJson(Map<String, dynamic> json) {
    if (json['roles'] != null) {
      roles = new List<Role>();
      json['roles'].forEach((v) {
        roles.add(new Role.fromJson(v));
      });
    }
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.roles != null) {
      data['roles'] = this.roles.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}