import 'package:flutter/material.dart';
import 'package:zephy_client/utils/color_util.dart';
import 'animated_loading_circle.dart';

//List<Color> loadingColors = [Color(0xFFC7E0FC), Color(0xFF318FFA), Color(0xFF0054B5)];
//List<Color> errorColors = [Color(0xFFFFA1A1), Color(0xFFFA3131), Color(0xFFB50000)];

List<Color> getLoadingColors(BuildContext context) {
  const double COLOR_DIFF_AMOUNT = 0.1;
  Color main = Theme.of(context).colorScheme.primary;
  return <Color>[darken(main, COLOR_DIFF_AMOUNT), main, lighten(main, COLOR_DIFF_AMOUNT)];
}

List<Color> getErrorColors(BuildContext context) {
  const double COLOR_DIFF_AMOUNT = 0.1;
  Color main = Theme.of(context).colorScheme.error;
  return <Color>[darken(main, COLOR_DIFF_AMOUNT), main, lighten(main, COLOR_DIFF_AMOUNT)];
}

class Loading extends StatelessWidget {
  final double totalSize;
  final double singleBallSize;
  final List<Color> colors;
  final bool static;


  Loading({this.totalSize = 75, this.singleBallSize = 25, this.colors, this.static = false});
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

    return AnimatedLoadingCircle(offset: offset, singleBallSize: singleBallSize, colors: colors);
  }
}