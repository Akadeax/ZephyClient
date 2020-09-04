import 'package:zephy_client/models/user_model.dart';

class Message {
  String author;
  String sId;
  String content;
  int sentAt;
  String channel;

  Message({this.author, this.sId, this.content, this.sentAt, this.channel});

  Message.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    sId = json['_id'];
    content = json['content'];
    sentAt = json['sentAt'];
    channel = json['channel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author'] = this.author;
    data['_id'] = this.sId;
    data['content'] = this.content;
    data['sentAt'] = this.sentAt;
    data['channel'] = this.channel;
    return data;
  }
}


class PopulatedMessage {
  User author;
  String sId;
  String content;
  int sentAt;
  String channel;

  PopulatedMessage(
      {this.author, this.sId, this.content, this.sentAt, this.channel});

  PopulatedMessage.fromJson(Map<String, dynamic> json) {
    author =
    json['author'] != null ? new User.fromJson(json['author']) : null;
    sId = json['_id'];
    content = json['content'];
    sentAt = json['sentAt'];
    channel = json['channel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.author != null) {
      data['author'] = this.author.toJson();
    }
    data['_id'] = this.sId;
    data['content'] = this.content;
    data['sentAt'] = this.sentAt;
    data['channel'] = this.channel;
    return data;
  }
}