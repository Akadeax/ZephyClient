import 'package:flutter/material.dart';
import 'package:widget_view/widget_view.dart';

class ListGradient extends StatelessWidget {
  final bool top;

  ListGradient({
    this.top = true,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => _ListGradientView(this);
}

class _ListGradientView extends StatelessWidgetView<ListGradient> {
  const _ListGradientView(ListGradient controller) : super(controller);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    List<Color> colors = [
      theme.colorScheme.background.withOpacity(1),
      theme.cardColor.withOpacity(0),
    ];

    if(!controller.top) colors = colors.reversed.toList();

    return Container(
      width: size.width,
      height: 20,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
    );
  }
}