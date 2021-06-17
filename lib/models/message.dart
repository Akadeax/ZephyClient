import 'package:zephy_client/models/user.dart';

class Message {
  String author;
  String sId;
  String content;
  int sentAt;

  Message({this.author, this.sId, this.content, this.sentAt});

  Message.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    sId = json['_id'];
    content = json['content'];
    sentAt = json['sentAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author'] = this.author;
    data['_id'] = this.sId;
    data['content'] = this.content;
    data['sentAt'] = this.sentAt;
    return data;
  }
}

class PopulatedMessage {
  BaseUser author;
  String sId;
  String content;
  int sentAt;

  PopulatedMessage(
      {this.author, this.sId, this.content, this.sentAt});

  PopulatedMessage.fromJson(Map<String, dynamic> json) {
    author =
    json['author'] != null ? new BaseUser.fromJson(json['author']) : null;
    sId = json['_id'];
    content = json['content'];
    sentAt = json['sentAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.author != null) {
      data['author'] = this.author.toJson();
    }
    data['_id'] = this.sId;
    data['content'] = this.content;
    data['sentAt'] = this.sentAt;
    return data;
  }
}