import 'dart:convert';

import 'package:zephy_client/models/message_model.dart';

import '../packet.dart';

class UpdateViewedChannelPacketData {
  String channelId;
  String lastMessageId;
  List<PopulatedMessage> missedMessages;

  UpdateViewedChannelPacketData(
      {this.channelId, this.lastMessageId, this.missedMessages});

  UpdateViewedChannelPacketData.fromJson(Map<String, dynamic> json) {
    channelId = json['channelId'];
    lastMessageId = json['lastMessageId'];
    if (json['missedMessages'] != null) {
      missedMessages = new List<PopulatedMessage>();
      json['missedMessages'].forEach((v) {
        missedMessages.add(new PopulatedMessage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channelId'] = this.channelId;
    data['lastMessageId'] = this.lastMessageId;
    if (this.missedMessages != null) {
      data['missedMessages'] =
          this.missedMessages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UpdateViewedChannelPacket extends Packet<UpdateViewedChannelPacketData> {
  static const int TYPE = 4001;

  UpdateViewedChannelPacket(UpdateViewedChannelPacketData data) : super(TYPE) {
    writePacketData(data);
  }

  UpdateViewedChannelPacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  UpdateViewedChannelPacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return UpdateViewedChannelPacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(UpdateViewedChannelPacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}
