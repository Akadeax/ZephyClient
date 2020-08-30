import 'dart:collection';

import 'package:zephy_client/packet/channel/accessible_channels_info_packet.dart';
import 'package:zephy_client/packet/packet.dart';
import 'package:zephy_client/services/server_connection.dart';

import 'auth/login_result_packet.dart';

class PacketReceiver {
  HashMap<int, PacketHandler> _handlers = HashMap<int, PacketHandler>();
  ServerConnection _conn;

  PacketReceiver(this._conn);

  void initHandlers() {
    _handlers[LoginResultPacket.TYPE] = LoginResultPacketHandler();
    _handlers[AccessibleChannelsInfoPacket.TYPE] = AccessibleChannelsInfoPacketHandler();
  }

  void handle(List<int> packet) {
    if(_handlers.length == 0) initHandlers();

    int packetType = Packet.getPacketTypeFromBuffer(packet);

    print("received packet $packetType");

    if(_handlers.containsKey(packetType)) {
      _handlers[packetType].handle(packet, _conn);
    }
  }
}
