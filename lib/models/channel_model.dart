import 'package:zephy_client/models/role_model.dart';

import 'message_model.dart';

class BaseChannelData {
  String sId;
  String name;
  String description;

  BaseChannelData({this.sId, this.name, this.description});

  BaseChannelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}

class Channel {
  List<String> roles;
  List<String> messages;
  String sId;
  String name;
  String description;

  Channel({this.roles, this.messages, this.sId, this.name, this.description});

  Channel.fromJson(Map<String, dynamic> json) {
    roles = json['roles'].cast<String>();
    messages = json['messages'].cast<String>();
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roles'] = this.roles;
    data['messages'] = this.messages;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}

class PopulatedChannel {
  List<Role> roles;
  List<Message> messages;
  String sId;
  String name;
  String description;

  PopulatedChannel({this.roles, this.messages, this.sId, this.name, this.description});

  PopulatedChannel.fromJson(Map<String, dynamic> json) {
    if (json['roles'] != null) {
      roles = new List<Role>();
      json['roles'].forEach((v) {
        roles.add(new Role.fromJson(v));
      });
    }
    if (json['messages'] != null) {
      messages = new List<Message>();
      json['messages'].forEach((v) {
        messages.add(new Message.fromJson(v));
      });
    }
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.roles != null) {
      data['roles'] = this.roles.map((v) => v.toJson()).toList();
    }
    if (this.messages != null) {
      data['messages'] = this.messages.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}