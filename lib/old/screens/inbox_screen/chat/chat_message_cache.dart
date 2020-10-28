import 'file:///D:/dev/Programming/Dart/Flutter/zephy_client/lib/models/channel_model.dart';
import 'file:///D:/dev/Programming/Dart/Flutter/zephy_client/lib/models/message_model.dart';
import 'package:zephy_client/packet/message/message_send_packet.dart';
import 'package:zephy_client/packet/message/populate_messages_packet.dart';
import 'package:zephy_client/services/profile_data.dart';
import 'chat_display.dart';
import 'package:zephy_client/services/sockets/server_connection.dart';

class ChatMessageCache {
  final ServerConnection _conn;
  final BaseChannelData _channelData;
  final ProfileData _profileData;

  ChatDisplayState _chatDisplay;

  int _nextPageToLoad = 0;

  List<PopulatedMessage> currentDisplayMessages = new List<PopulatedMessage>();

  bool disposed = false;
  ChatMessageCache(this._chatDisplay, this._conn, this._channelData, this._profileData) {
    _receiveMessages();
  }

  void _receiveMessages() async {
    while(true) {
      if(disposed) return;
      MessageSendPacket msgSend = await _conn.packetHandler.waitForPacket<MessageSendPacket>(
          MessageSendPacket.TYPE,
          (buffer) => MessageSendPacket.fromBuffer(buffer)
      );
      if(msgSend == null) return;

      currentDisplayMessages.insert(0, msgSend.readPacketData().returnMessage);
      _chatDisplay.updateDisplay();
    }
  }


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
        user: _profileData.loggedInUser.sId,
        page: page
    ));
    _conn.sendPacket(packet);

    var recvPacket = await _conn.packetHandler.waitForPacket<PopulateMessagesPacket>(
        PopulateMessagesPacket.TYPE,
            (buffer) => PopulateMessagesPacket.fromBuffer(buffer)
    );
    if(recvPacket == null) return null;

    PopulateMessagesPacketData data = recvPacket.readPacketData();
    if(data == null) return null;

    return data.populatedMessages;
  }

  void dispose() {}
}
