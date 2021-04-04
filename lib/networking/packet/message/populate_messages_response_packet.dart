import 'dart:convert';

import 'package:zephy_client/networking/packet/packet.dart';

class PopulateMessagesResponsePacketData extends PacketData {
  int httpStatus;
  String user;

  PopulateMessagesResponsePacketData({this.httpStatus, this.user});

  PopulateMessagesResponsePacketData.fromJson(Map<String, dynamic> json) {
    httpStatus = json['httpStatus'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['httpStatus'] = this.httpStatus;
    data['user'] = this.user;
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