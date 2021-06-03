import 'dart:convert';

import 'package:zephy_client/networking/packet/packet.dart';

class FetchMembersRequestPacketData extends PacketData {
  String channel;

  FetchMembersRequestPacketData({this.channel});

  FetchMembersRequestPacketData.fromJson(Map<String, dynamic> json) {
    channel = json['channel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channel'] = this.channel;
    return data;
  }
}

class FetchMembersRequestPacket extends Packet<FetchMembersRequestPacketData> {
  static const int TYPE = 5003;
  FetchMembersRequestPacket(FetchMembersRequestPacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  FetchMembersRequestPacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  FetchMembersRequestPacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return FetchMembersRequestPacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(FetchMembersRequestPacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}