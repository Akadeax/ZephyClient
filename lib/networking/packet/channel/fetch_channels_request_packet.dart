import 'dart:convert';

import 'package:zephy_client/networking/packet/packet.dart';

class FetchChannelsRequestPacketData extends PacketData {
  String forUser;

  FetchChannelsRequestPacketData({this.forUser});

  FetchChannelsRequestPacketData.fromJson(Map<String, dynamic> json) {
    forUser = json['forUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['forUser'] = this.forUser;
    return data;
  }
}

class FetchChannelsPacket extends Packet<FetchChannelsRequestPacketData> {
  static const int TYPE = 3001;
  FetchChannelsPacket(FetchChannelsRequestPacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  FetchChannelsPacket.fromBuffer(List<int> buffer)
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