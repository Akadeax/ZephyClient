

import 'dart:convert';

import 'package:zephy_client/models/message_model.dart';

import '../packet.dart';

class PopulateMessagesPacketData {
  String forChannel = "";
  List<PopulatedMessage> populatedMessages = new List<PopulatedMessage>();
  int page = 0;

  PopulateMessagesPacketData(
      {this.forChannel, this.populatedMessages, this.page});

  PopulateMessagesPacketData.fromJson(Map<String, dynamic> json) {
    forChannel = json['forChannel'];
    if (json['populatedMessages'] != null) {
      populatedMessages = new List<PopulatedMessage>();
      json['populatedMessages'].forEach((v) {
        populatedMessages.add(new PopulatedMessage.fromJson(v));
      });
    }
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['forChannel'] = this.forChannel;
    if (this.populatedMessages != null) {
      data['populatedMessages'] =
          this.populatedMessages.map((v) => v.toJson()).toList();
    }
    data['page'] = this.page;
    return data;
  }
}


class PopulateMessagesPacket extends Packet<PopulateMessagesPacketData> {
  static const int TYPE = 4000;

  PopulateMessagesPacket(PopulateMessagesPacketData data) : super(TYPE) {
    writePacketData(data);
  }

  PopulateMessagesPacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  PopulateMessagesPacketData readPacketData() {
    try {
      String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
      return PopulateMessagesPacketData.fromJson(jsonDecode(jsonString));
    } catch(e) { return null; }
  }

  @override
  void writePacketData(PopulateMessagesPacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}
