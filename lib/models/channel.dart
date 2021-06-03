import 'message.dart';

class Channel {
  List<String> members;
  String sId;
  String name;

  Channel({this.members, this.sId, this.name});

  Channel.fromJson(Map<String, dynamic> json) {
    members = json['members'].cast<String>();
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['members'] = this.members;
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }

  BaseChannelData toBaseChannelData() {
    return BaseChannelData(
      sId: this.sId,
      name: this.name,
    );
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