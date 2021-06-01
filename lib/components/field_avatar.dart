import 'package:flutter/material.dart';
import 'package:widget_view/widget_view.dart';
import 'package:zephy_client/util/color_util.dart';

class FieldAvatar extends StatelessWidget {
  final String sId;
  final String baseText;
  final double size;
  FieldAvatar({
    @required this.sId,
    @required this.baseText,
    this.size = 25,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => _FieldAvatarView(this);

  String getCompressedText() {
    var split = baseText.split(' ');
    if(split.length == 2) return "${split[0][0]}${split[1][0]}".toUpperCase();
    else return split[0][0].toUpperCase();
  }
}

class _FieldAvatarView extends StatelessWidgetView<FieldAvatar> {
  const _FieldAvatarView(FieldAvatar controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: avatarColor(controller.sId),
      child: Text(
        controller.getCompressedText(),
        style: TextStyle(
          fontSize: 17,
          color: Colors.white,
        ),
      )
    );
  }
}