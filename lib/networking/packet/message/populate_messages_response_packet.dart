import 'dart:convert';

import 'package:zephy_client/models/message.dart';
import 'package:zephy_client/networking/packet/packet.dart';

class PopulateMessagesResponsePacketData extends PacketData {
  int httpStatus;
  int page;
  List<PopulatedMessage> fetchedMessages;

  PopulateMessagesResponsePacketData({this.httpStatus, this.fetchedMessages});

  PopulateMessagesResponsePacketData.fromJson(Map<String, dynamic> json) {
    httpStatus = json['httpStatus'];
    page = json['page'];
    if (json['fetchedMessages'] != null) {
      fetchedMessages = <PopulatedMessage>[];
      json['fetchedMessages'].forEach((v) {
        fetchedMessages.add(new PopulatedMessage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['httpStatus'] = this.httpStatus;
    data['page'] = this.page;
    if (this.fetchedMessages != null) {
      data['fetchedMessages'] =
          this.fetchedMessages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PopulateMessagesResponsePacket extends Packet<PopulateMessagesResponsePacketData> {
  static const int TYPE = 4002;
  PopulateMessagesResponsePacket(PopulateMessagesResponsePacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  PopulateMessagesResponsePacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  PopulateMessagesResponsePacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return PopulateMessagesResponsePacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(PopulateMessagesResponsePacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}