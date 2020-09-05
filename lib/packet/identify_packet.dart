import 'dart:convert';
import 'packet.dart';

class IdentifyPacketData extends PacketData {
  String src = "CLIENT";

  IdentifyPacketData({this.src});

  IdentifyPacketData.fromJson(Map<String, dynamic> json) {
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['src'] = this.src;
    return data;
  }
}


class IdentifyPacket extends Packet<IdentifyPacketData> {
  static const int TYPE = 1000;
  IdentifyPacket(IdentifyPacketData data) : super(TYPE, data) {
    writePacketData(data);
  }

  IdentifyPacket.fromBuffer(List<int> buffer)
      : super.fromBuffer(buffer);

  @override
  IdentifyPacketData readPacketData() {
    String jsonString = readString(Packet.BASE_PACKET_SIZE, buffer.length - Packet.BASE_PACKET_SIZE);
    return IdentifyPacketData.fromJson(jsonDecode(jsonString));
  }

  @override
  void writePacketData(IdentifyPacketData data) {
    Map<String, dynamic> jsonMap = data.toJson();
    String jsonString = jsonEncode(jsonMap);
    writeString(jsonString, Packet.BASE_PACKET_SIZE);
  }
}