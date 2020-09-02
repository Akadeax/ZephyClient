import 'package:zephy_client/models/channel_model.dart';
import 'package:zephy_client/models/message_model.dart';
import 'package:zephy_client/packet/message/populate_messages_packet.dart';
import 'package:zephy_client/services/server_connection.dart';

class ChatMessageCache {
  ServerConnection _conn;
  BaseChannelData _channelData;
  ChatMessageCache(this._conn, this._channelData) {
    loadNextPage();
  }

  int _nextPageToLoad = 0;

  List<PopulatedMessage> currentDisplayMessages = new List<PopulatedMessage>();

  void loadNextPage() async {
    var fetchedPage = await _fetchMessages(_nextPageToLoad++);
    currentDisplayMessages.addAll(fetchedPage);
  }

  Future<List<PopulatedMessage>> _fetchMessages(int page) async {
    PopulateMessagesPacket packet = PopulateMessagesPacket(PopulateMessagesPacketData(
      forChannel: _channelData.sId,
      page: page,
    ));
    _conn.sendPacket(packet);

    PopulateMessagesPacket recvPacket = await _conn.waitForPacket<PopulateMessagesPacket>((buffer) => PopulateMessagesPacket.fromBuffer(buffer));
    PopulateMessagesPacketData data = recvPacket.readPacketData();

    return data.populatedMessages;
  }
}
