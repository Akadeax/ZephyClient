import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_view/widget_view.dart';
import 'package:zephy_client/components/list_gradient.dart';
import 'package:zephy_client/providers/current_channel.dart';
import 'package:zephy_client/screens/chat_screen/single_message_display.dart';

class MessageListDisplay extends StatefulWidget {
  MessageListDisplay({Key key}) : super(key: key);

  @override
  _MessageListDisplayController createState() => _MessageListDisplayController();
}

class _MessageListDisplayController extends State<MessageListDisplay> {
  @override
  Widget build(BuildContext context) => _MessageListDisplayView(this);

  CurrentChannel channel;
  ScrollController scrollController;

  @override
  void initState() {
    channel = Provider.of<CurrentChannel>(context, listen: false);
    channel.fetchNextPage(context);

    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  bool get listEndReached =>
      scrollController.offset >= scrollController.position.maxScrollExtent
      && !scrollController.position.outOfRange;

  void _scrollListener() {
    if(listEndReached) {
      channel.fetchNextPage(context);
    }
  }

  Widget itemBuilder(BuildContext context, int i) {
    return SingleMessageDisplay(
        message: channel.fetchedMessages[i]
    );
  }
}

class _MessageListDisplayView extends StatefulWidgetView<MessageListDisplay, _MessageListDisplayController> {
  const _MessageListDisplayView(_MessageListDisplayController controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Consumer<CurrentChannel>(
          builder: (ctx, _, __) {
            return ListView.builder(
              controller: controller.scrollController,
              reverse: true,
              itemCount: controller.channel.fetchedMessages.length,
              itemBuilder: controller.itemBuilder,
            );
          }
        ),
        Positioned(
          top: 0,
          child: ListGradient(top: true),
        ),
      ],
    );
  }
}
