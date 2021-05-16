import 'dart:convert';

import 'package:zephy_client/services/networking/packet/packet.dart';

class FetchUserListRequestPacketData extends PacketData {
  String search;

  FetchUserListRequestPacketData({this.search});

  FetchUserListRequestPacketData.fromJson(Map<String, dynamic> json) {
    search = json['search'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search'] = this.search;
    return data;
  }
}

class FetchUserListRequestPacket extends Packet<FetchUserListRequestPacketData> {
  static const int TYPE = 5001;
  FetchUserListRequestPacket(FetchUserListRequestPacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  FetchUserListRequestPacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  FetchUserListRequestPacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return FetchUserListRequestPacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(FetchUserListRequestPacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}