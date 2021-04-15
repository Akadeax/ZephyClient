import 'dart:convert';

import 'package:zephy_client/services/networking/packet/packet.dart';

class CreateChannelRequestPacketData extends PacketData {
  String name;
  List<String> withMembers;

  CreateChannelRequestPacketData({this.name, this.withMembers});

  CreateChannelRequestPacketData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    withMembers = json['withMembers'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['withMembers'] = this.withMembers;
    return data;
  }
}

class CreateChannelRequestPacket extends Packet<CreateChannelRequestPacketData> {
  static const int TYPE = 3003;
  CreateChannelRequestPacket(CreateChannelRequestPacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  CreateChannelRequestPacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  CreateChannelRequestPacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return CreateChannelRequestPacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(CreateChannelRequestPacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}