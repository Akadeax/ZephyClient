import 'package:zephy_client/models/channel_model.dart';
import 'package:zephy_client/models/message_model.dart';
import 'package:zephy_client/packet/message/populate_messages_packet.dart';
import 'chat_display.dart';
import 'package:zephy_client/services/sockets/server_connection.dart';

class ChatMessageCache {
  final ServerConnection _conn;
  final BaseChannelData _channelData;

  ChatDisplayState _chatDisplay;

  ChatMessageCache(this._chatDisplay, this._conn, this._channelData);

  int _nextPageToLoad = 0;

  List<PopulatedMessage> currentDisplayMessages = new List<PopulatedMessage>();

  Future<void> loadNextPage() async {
    var fetchedPage = await _fetchMessages(_nextPageToLoad);

    if(fetchedPage != null && fetchedPage.isNotEmpty) {
      _nextPageToLoad++;
      currentDisplayMessages.addAll(fetchedPage);

      _chatDisplay.updateDisplay();
    }
  }

  Future<List<PopulatedMessage>> _fetchMessages(int page) async {
    PopulateMessagesPacket packet = PopulateMessagesPacket(PopulateMessagesPacketData(
        forChannel: _channelData.sId,
        page: page
    ));
    _conn.sendPacket(packet);

    var recvPacket = await _conn.packetHandler.waitForPacket<PopulateMessagesPacket>(
        PopulateMessagesPacket.TYPE,
            (buffer) => PopulateMessagesPacket.fromBuffer(buffer)
    );

    PopulateMessagesPacketData data = recvPacket.readPacketData();
    if(data == null) return null;

    return data.populatedMessages;
  }

  void dispose() {}
}
