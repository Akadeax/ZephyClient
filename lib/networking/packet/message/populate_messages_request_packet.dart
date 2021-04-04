import 'dart:convert';

import 'package:zephy_client/networking/packet/packet.dart';

class PopulateMessagesRequestPacketData extends PacketData {
  String forChannel;
  int page;

  PopulateMessagesRequestPacketData({this.forChannel, this.page});

  PopulateMessagesRequestPacketData.fromJson(Map<String, dynamic> json) {
    forChannel = json['forChannel'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['forChannel'] = this.forChannel;
    data['page'] = this.page;
    return data;
  }
}

class PopulateMessagesRequestPacket extends Packet<PopulateMessagesRequestPacketData> {
  static const int TYPE = 4001;
  PopulateMessagesRequestPacket(PopulateMessagesRequestPacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  PopulateMessagesRequestPacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  PopulateMessagesRequestPacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return PopulateMessagesRequestPacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(PopulateMessagesRequestPacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}