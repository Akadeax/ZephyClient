import 'package:zephy_client/models/user.dart';

import 'message.dart';

class Channel {
  List<String> messages;
  List<String> members;
  String sId;
  String name;

  Channel({this.messages, this.members, this.sId, this.name});

  Channel.fromJson(Map<String, dynamic> json) {
    messages = json['messages'].cast<String>();
    members = json['members'].cast<String>();
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messages'] = this.messages;
    data['members'] = this.members;
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}

class BaseChannelData {
  Message lastMessage;
  String sId;
  String name;

  BaseChannelData({this.lastMessage, this.sId, this.name});

  BaseChannelData.fromJson(Map<String, dynamic> json) {
    lastMessage = json['lastMessage'] != null
        ? new Message.fromJson(json['lastMessage'])
        : null;
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lastMessage != null) {
      data['lastMessage'] = this.lastMessage.toJson();
    }
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}


class PopulatedChannel {
  List<Message> messages;
  List<User> members;
  String sId;
  String name;

  PopulatedChannel({this.messages, this.members, this.sId, this.name});

  PopulatedChannel.fromJson(Map<String, dynamic> json) {
    if (json['messages'] != null) {
      messages = <Message>[];
      json['messages'].forEach((v) {
        messages.add(new Message.fromJson(v));
      });
    }
    if (json['members'] != null) {
      members = <User>[];
      json['members'].forEach((v) {
        members.add(new User.fromJson(v));
      });
    }
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.messages != null) {
      data['messages'] = this.messages.map((v) => v.toJson()).toList();
    }
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}