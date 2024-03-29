import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:widget_view/widget_view.dart';
import 'package:zephy_client/components/first_build_fade_in.dart';
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
    channel.initialFetch();

    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  bool get listEndReached =>
      scrollController.offset >= scrollController.position.maxScrollExtent
      && !scrollController.position.outOfRange;

  void _scrollListener() {
    if(listEndReached) {
      channel.fetchNextPage();
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
    return FirstBuildFadeIn(
      delay: const Duration(milliseconds: 100),
      child: Consumer<CurrentChannel>(
        builder: (ctx, _, __) {
          return ListView.builder(
            controller: controller.scrollController,
            reverse: true,
            itemCount: controller.channel.fetchedMessages.length,
            itemBuilder: controller.itemBuilder,
          );
        }
      ),
    );
  }
}
