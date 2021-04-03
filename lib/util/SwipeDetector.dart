import 'package:flutter/material.dart';

class SwipeSensitivity {
  double verticalMinDisplacement = 50.0;

  double verticalMaxThreshold = 100.0;
  double verticalMinVelocity = 300.0;
  double horizontalMinDisplacement = 50.0;
  double horizontalMaxThreshold = 100.0;
  double horizontalMinVelocity = 300.0;

  SwipeSensitivity(
      {@required this.verticalMinDisplacement,
      @required this.verticalMaxThreshold,
      @required this.verticalMinVelocity,
      @required this.horizontalMinDisplacement,
      @required this.horizontalMaxThreshold,
      @required this.horizontalMinVelocity});
}

class SwipeDetector extends StatelessWidget {
  final Widget child;

  final Function() onSwipeUp;
  final Function() onSwipeDown;
  final Function() onSwipeRight;
  final Function() onSwipeLeft;
  final SwipeSensitivity swipeSensitivity;

  const SwipeDetector(
      {Key key,
      @required @required this.child,
      @required this.onSwipeUp,
      @required this.onSwipeDown,
      @required this.onSwipeRight,
      @required this.onSwipeLeft,
      @required this.swipeSensitivity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('building 31 ');
    DragStartDetails verticalStartDetails;
    DragUpdateDetails verticalUpdateDetails;

    DragStartDetails horizontalStartDetails;
    DragUpdateDetails horizontalUpdateDetails;

    return GestureDetector(
      onVerticalDragStart: (details) {
        verticalStartDetails = details;
      },
      onVerticalDragUpdate: (details) {
        verticalUpdateDetails = details;
      },
      onVerticalDragEnd: (details) {
        var dx = verticalUpdateDetails.globalPosition.dx -
            verticalStartDetails.globalPosition.dx;
        var dy = verticalUpdateDetails.globalPosition.dy -
            verticalStartDetails.globalPosition.dy;
        var velocity = details.primaryVelocity;

        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        double positiveVelocity = velocity < 0 ? -velocity : velocity;

        if (dx > swipeSensitivity.verticalMaxThreshold) return;
        if (dy < swipeSensitivity.verticalMinDisplacement) return;
        if (positiveVelocity < swipeSensitivity.verticalMinVelocity) return;

        if (velocity < 0) {
          if (onSwipeUp != null) {
            onSwipeUp();
          }
        } else {
          if (onSwipeDown != null) {
            onSwipeDown();
          }
        }
      },
      onHorizontalDragStart: (details) {
        horizontalStartDetails = details;
      },
      onHorizontalDragUpdate: (details) {
        horizontalUpdateDetails = details;
      },
      onHorizontalDragEnd: (details) {
        var dx = horizontalUpdateDetails.globalPosition.dx -
            horizontalStartDetails.globalPosition.dx;
        var dy = horizontalUpdateDetails.globalPosition.dy -
            horizontalStartDetails.globalPosition.dy;
        var velocity = details.primaryVelocity;

        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;
        double positiveVelocity = velocity < 0 ? -velocity : velocity;

        if (dx > swipeSensitivity.horizontalMaxThreshold) return;
        if (dy < swipeSensitivity.horizontalMinDisplacement) return;
        if (positiveVelocity < swipeSensitivity.horizontalMinVelocity) return;

        if (velocity < 0) {
          if (onSwipeUp != null) {
            onSwipeLeft();
          }
        } else {
          if (onSwipeDown != null) {
            onSwipeRight();
          }
        }
      },
    );
  }
}
