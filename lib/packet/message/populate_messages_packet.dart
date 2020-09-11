

import 'dart:convert';

import 'package:zephy_client/models/message_model.dart';

import '../packet.dart';

class PopulateMessagesPacketData extends PacketData {
  String forChannel = "";
  int page = 0;
  String user = "";
  List<PopulatedMessage> populatedMessages = new List<PopulatedMessage>();

  PopulateMessagesPacketData(
      {this.forChannel, this.user, this.page, this.populatedMessages});

  PopulateMessagesPacketData.fromJson(Map<String, dynamic> json) {
    forChannel = json['forChannel'];
    user = json['user'];
    page = json['page'];
    if (json['populatedMessages'] != null) {
      populatedMessages = new List<PopulatedMessage>();
      json['populatedMessages'].forEach((v) {
        populatedMessages.add(new PopulatedMessage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['user'] = this.user;
    data['forChannel'] = this.forChannel;
    if (this.populatedMessages != null) {
      data['populatedMessages'] =
          this.populatedMessages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PopulateMessagesPacket extends Packet<PopulateMessagesPacketData> {
  static const int TYPE = 4000;

  PopulateMessagesPacket(PopulateMessagesPacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  PopulateMessagesPacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  PopulateMessagesPacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return PopulateMessagesPacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(PopulateMessagesPacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}
