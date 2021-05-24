import 'dart:convert';

import 'package:zephy_client/networking/packet/packet.dart';

class FetchChannelsRequestPacketData extends PacketData {
  String search;

  FetchChannelsRequestPacketData({this.search});

  FetchChannelsRequestPacketData.fromJson(Map<String, dynamic> json) {
    search = json['search'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search'] = this.search;
    return data;
  }
}

class FetchChannelsRequestPacket extends Packet<FetchChannelsRequestPacketData> {
  static const int TYPE = 3001;
  FetchChannelsRequestPacket(FetchChannelsRequestPacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  FetchChannelsRequestPacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  FetchChannelsRequestPacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return FetchChannelsRequestPacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(FetchChannelsRequestPacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}