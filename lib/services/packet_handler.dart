import 'dart:typed_data';

import 'package:zephy_client/packet/auth/login_result_packet.dart';
import 'package:zephy_client/packet/channel/accessible_channels_info_packet.dart';
import 'package:zephy_client/packet/identify_packet.dart';
import 'package:zephy_client/packet/message/populate_messages_packet.dart';
import 'package:zephy_client/packet/message/update_viewed_channel_packet.dart';
import 'package:zephy_client/packet/packet.dart';
import 'package:zephy_client/services/server_connection.dart';

typedef S ItemCreator<S>(List<int> buffer);

class PacketHandler {
  static Map<int, Type> _packetTypes = {
    IdentifyPacket.TYPE: IdentifyPacket.fromBuffer(null).runtimeType,
    LoginResultPacket.TYPE: LoginResultPacket.fromBuffer(null).runtimeType,
    AccessibleChannelsInfoPacket.TYPE: AccessibleChannelsInfoPacket.fromBuffer(null).runtimeType,
    PopulateMessagesPacket.TYPE: PopulateMessagesPacket.fromBuffer(null).runtimeType,
    UpdateViewedChannelPacket.TYPE: UpdateViewedChannelPacket.fromBuffer(null).runtimeType,
  };

  ServerConnection _conn;
  PacketHandler(this._conn);

  Future<TPacketType> waitForPacket<TPacketType>(ItemCreator<TPacketType> creator) async {
    print("starting to wait for packet...");
    await for(Uint8List data in _conn.broadcastStream.stream) {
      int packetType = Packet.getPacketTypeFromBuffer(data);
      if(!_packetTypes.containsKey(packetType)) continue;

      print("got packet ($packetType).");
      return creator(data);
    }

    print("cancelling waiting for packet.");
    return null;
  }
}
