import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'animated_loading_circle.dart';

List<Color> loadingColors = [Color(0xFFC7E0FC), Color(0xFF318FFA), Color(0xFF0054B5)];
List<Color> errorColors = [Color(0xFFFFA1A1), Color(0xFFFA3131), Color(0xFFB50000)];

class LoadingState with ChangeNotifier {
  List<Color> _currentColors = loadingColors;

  List<Color> get currentColors => _currentColors;
  set currentColors(List<Color> newColors) {
    _currentColors = newColors;
    notifyListeners();
  }
}

class Loading extends StatelessWidget {
  final double totalSize;
  final double singleBallSize;

  final bool static;

  final LoadingState state = LoadingState();

  Loading({this.totalSize = 75, this.singleBallSize = 25, this.static = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: totalSize,
      height: totalSize,
      child: ChangeNotifierProvider.value(
        value: state,
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
          color: state.currentColors[offset]
        ),
      );
    }

    return AnimatedLoadingCircle(offset: offset, singleBallSize: singleBallSize);
  }
}