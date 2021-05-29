import 'package:flutter/material.dart';
import 'package:widget_view/widget_view.dart';
import 'package:zephy_client/models/channel.dart';

class ChatScreen extends StatefulWidget {
  final BaseChannelData channel;

  ChatScreen(this.channel, {Key key}) : super(key: key);

  @override
  _ChatScreenController createState() => _ChatScreenController();
}

class _ChatScreenController extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) => _ChatScreenView(this);
}

class _ChatScreenView extends StatefulWidgetView<ChatScreen, _ChatScreenController> {
  const _ChatScreenView(_ChatScreenController controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(

      )
    );
  }
}