import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephy_client/utils/list_util.dart';

import 'loading.dart';

List<Color> loadingColor = [];
List<Color> errorColor = [];

List<TweenSequenceItem<Color>> rotatingColor([List<Color> colors]) {
  if(colors == null) colors = [Colors.black, Colors.black, Colors.black];

  List<TweenSequenceItem<Color>> newList = [];
  for(int i = 0; i < colors.length; i++) {
    Color secondCol = i + 1 < colors.length ? colors[i + 1] : colors[0];
    newList.add(TweenSequenceItem(tween: ColorTween(begin: colors[i], end: secondCol), weight: 1.0));
  }
  return newList;
}

class AnimatedLoadingCircle extends StatefulWidget {
  final int offset;
  final List<Color> initialColors;
  final double singleBallSize;

  AnimatedLoadingCircle({Key key, @required this.offset, this.initialColors, this.singleBallSize = 30}) : super(key: key);

  @override
  AnimatedLoadingCircleState createState() => AnimatedLoadingCircleState();
}


class AnimatedLoadingCircleState extends State<AnimatedLoadingCircle> with SingleTickerProviderStateMixin  {
  AnimationController _controller;
  Animation<Color> _colorAnim;
  List<Color> _currentColors;


  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward()..repeat();

    setAnim(widget.initialColors, widget.offset);
    super.initState();
  }

  void setAnim(List<Color> colors, int tweenOffset) {
    _currentColors = colors;
    _colorAnim = TweenSequence<Color>(rotate(rotatingColor(colors), tweenOffset)).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    LoadingState state = Provider.of<LoadingState>(context);
    if(state.currentColors != _currentColors) {
      setAnim(state.currentColors, widget.offset);
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (ctx, _) {
        return Container(
          width: widget.singleBallSize,
          height: widget.singleBallSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _colorAnim.value,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
