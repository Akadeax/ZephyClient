import 'dart:convert';

import 'package:zephy_client/models/channel.dart';
import 'package:zephy_client/networking/packet/packet.dart';

class CreateChannelResponsePacketData extends PacketData {
  int httpStatus;
  Channel newChannel;

  CreateChannelResponsePacketData({this.httpStatus, this.newChannel});

  CreateChannelResponsePacketData.fromJson(Map<String, dynamic> json) {
    httpStatus = json['httpStatus'];
    newChannel = json['newChannel'] != null
        ? new Channel.fromJson(json['newChannel'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['httpStatus'] = this.httpStatus;
    if (this.newChannel != null) {
      data['newChannel'] = this.newChannel.toJson();
    }
    return data;
  }
}

class CreateChannelResponsePacket extends Packet<CreateChannelResponsePacketData> {
  static const int TYPE = 3004;
  CreateChannelResponsePacket(CreateChannelResponsePacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  CreateChannelResponsePacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  CreateChannelResponsePacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return CreateChannelResponsePacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(CreateChannelResponsePacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}