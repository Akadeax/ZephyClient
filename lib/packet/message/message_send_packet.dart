import 'dart:convert';

import 'package:zephy_client/models/message_model.dart';
import 'package:zephy_client/packet/packet.dart';

class MessageSendPacketData extends PacketData {
  String message;
  String channel;
  String author;
  PopulatedMessage returnMessage;

  MessageSendPacketData(
      {this.message, this.channel, this.author, this.returnMessage});

  MessageSendPacketData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    channel = json['channel'];
    author = json['author'];
    returnMessage = json['returnMessage'] != null
        ? new PopulatedMessage.fromJson(json['returnMessage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['channel'] = this.channel;
    data['author'] = this.author;
    if (this.returnMessage != null) {
      data['returnMessage'] = this.returnMessage.toJson();
    }
    return data;
  }
}

class MessageSendPacket extends Packet<MessageSendPacketData> {
  static const int TYPE = 4001;

  MessageSendPacket(MessageSendPacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  MessageSendPacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  MessageSendPacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return MessageSendPacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(MessageSendPacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}