import 'dart:convert';

import 'package:zephy_client/models/user.dart';
import 'package:zephy_client/services/networking/packet/packet.dart';

class ConfirmSessionResponsePacketData extends PacketData {
  int httpStatus;
  User user;

  ConfirmSessionResponsePacketData({this.httpStatus, this.user});

  ConfirmSessionResponsePacketData.fromJson(Map<String, dynamic> json) {
    httpStatus = json['httpStatus'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['httpStatus'] = this.httpStatus;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class ConfirmSessionResponsePacket extends Packet<ConfirmSessionResponsePacketData> {
  static const int TYPE = 2004;
  ConfirmSessionResponsePacket(ConfirmSessionResponsePacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  ConfirmSessionResponsePacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  ConfirmSessionResponsePacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return ConfirmSessionResponsePacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(ConfirmSessionResponsePacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}