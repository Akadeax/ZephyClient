import 'dart:convert';

import 'package:zephy_client/models/channel.dart';
import 'package:zephy_client/networking/packet/packet.dart';

class FetchChannelsResponsePacketData extends PacketData {
  int httpStatus;
  List<BaseChannelData> channels;

  FetchChannelsResponsePacketData({this.httpStatus, this.channels});

  FetchChannelsResponsePacketData.fromJson(Map<String, dynamic> json) {
    httpStatus = json['httpStatus'];
    if (json['channels'] != null) {
      channels = <BaseChannelData>[];
      json['channels'].forEach((v) {
        channels.add(new BaseChannelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['httpStatus'] = this.httpStatus;
    if (this.channels != null) {
      data['channels'] = this.channels.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FetchChannelsResponsePacket extends Packet<FetchChannelsResponsePacketData> {
  static const int TYPE = 3002;
  FetchChannelsResponsePacket(FetchChannelsResponsePacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  FetchChannelsResponsePacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  FetchChannelsResponsePacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return FetchChannelsResponsePacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(FetchChannelsResponsePacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}