import 'package:flutter/material.dart';
import 'package:zephy_client/util/color_util.dart';
import 'animated_loading_circle.dart';

List<Color> getLoadingColors(BuildContext context) {
  const double COLOR_DIFF_AMOUNT = 0.1;
  Color sec = Theme.of(context).colorScheme.secondary;
  return <Color>[darken(sec, COLOR_DIFF_AMOUNT), sec, lighten(sec, COLOR_DIFF_AMOUNT)];
}

List<Color> getErrorColors(BuildContext context) {
  const double COLOR_DIFF_AMOUNT = 0.1;
  Color err = Theme.of(context).colorScheme.error;
  return <Color>[darken(err, COLOR_DIFF_AMOUNT), err, lighten(err, COLOR_DIFF_AMOUNT)];
}

class Loading extends StatelessWidget {
  final double totalSize;
  final double singleBallSize;
  final List<Color> colors;
  final bool static;
  final double animationSpeed;

  Loading({this.totalSize = 75, this.singleBallSize = 25, this.colors, this.static = false, this.animationSpeed});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: totalSize,
      height: totalSize,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: singleCircle(0),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: singleCircle(1),
          ),
          Positioned(
            bottom: 0,
            child: singleCircle(2),
          ),
        ],
      ),
    );
  }

  Widget singleCircle(int offset) {
    if(static) {
      return Container(
        width: singleBallSize,
        height: singleBallSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors[offset]
        ),
      );
    }

    return AnimatedLoadingCircle(offset: offset, singleBallSize: singleBallSize, colors: colors, animationSpeed: animationSpeed);
  }
}