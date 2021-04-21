import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ZephyLogo extends StatelessWidget {
  final double size;
  final Color color;

  const ZephyLogo({this.size = 50, this.color});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return SvgPicture.asset(
      "", // TODO: add logo asset
      clipBehavior: Clip.antiAlias,
      color: color == null ? theme.colorScheme.primary : color,
      fit: BoxFit.fill,
      height: size,
      width: size,
    );
  }
}
