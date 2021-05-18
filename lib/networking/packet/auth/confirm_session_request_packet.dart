import 'dart:convert';

import 'package:zephy_client/networking/packet/packet.dart';



class ConfirmSessionRequestPacketData extends PacketData {
  String accessToken;

  ConfirmSessionRequestPacketData({this.accessToken});

  ConfirmSessionRequestPacketData.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    return data;
  }
}

class ConfirmSessionRequestPacket extends Packet<ConfirmSessionRequestPacketData> {
  static const int TYPE = 2003;
  ConfirmSessionRequestPacket(ConfirmSessionRequestPacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  ConfirmSessionRequestPacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  ConfirmSessionRequestPacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return ConfirmSessionRequestPacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(ConfirmSessionRequestPacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}