import 'package:flutter/foundation.dart';
import 'package:zephy_client/models/user_model.dart';
import 'package:zephy_client/packet/channel/accessible_channels_info_packet.dart';
import 'package:zephy_client/services/sockets/server_connection.dart';

class ProfileData with ChangeNotifier {
  PopulatedUser _loggedInUser;

  PopulatedUser get loggedInUser
      => _loggedInUser;

  set loggedInUser(PopulatedUser newUser) {
    _loggedInUser = newUser;
    notifyListeners();
  }

  /// get all the data of the channels that 'loggedInUser' has access to in accordance with his roles.
  Future<AccessibleChannelsInfoPacketData> fetchAccessibleChannels(ServerConnection conn) async {
    var packet = AccessibleChannelsInfoPacket(AccessibleChannelsInfoPacketData(
        forUser: loggedInUser.sId
    ));
    conn.sendPacket(packet);

    var recvPacket = await conn.packetHandler.waitForPacket<AccessibleChannelsInfoPacket>(
        AccessibleChannelsInfoPacket.TYPE,
        (buffer) => AccessibleChannelsInfoPacket.fromBuffer(buffer)
    );
    return recvPacket.readPacketData();
  }
}
