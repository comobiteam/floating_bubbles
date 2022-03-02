import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum OffsetProps { x, y }

class BubbleAnimation {
  final Duration bubbleSpeed;
  final Color bubbleColor;
  final Random randomValue;

  BubbleAnimation({
    required this.bubbleColor,
    required this.randomValue,
    this.bubbleSpeed = const Duration(seconds: 3),
  }) {
    _restart();
    _shuffle();
  }

  late double size;
  late Duration duration;
  late Duration startTime;
  late MultiTween<OffsetProps> tween;

  /// Restarts the floating bubble animation.
  _restart() {
    final startPosition = Offset(
      -0.2 + 1.4 * randomValue.nextDouble(),
      1.2,
    );
    final endPosition = Offset(
      -0.2 + 1.4 * randomValue.nextDouble(),
      -0.2,
    );

    tween = MultiTween<OffsetProps>()
      ..add(
        OffsetProps.x,
        Tween(
          begin: startPosition.dx,
          end: endPosition.dx,
        ),
      )
      ..add(
        OffsetProps.y,
        Tween(
          begin: startPosition.dy,
          end: endPosition.dy,
        ),
      );

    duration = bubbleSpeed +
        Duration(
          milliseconds: randomValue.nextInt(6000),
        );

    startTime = Duration(
      milliseconds: DateTime.now().millisecondsSinceEpoch,
    );

    size = 0.2 + randomValue.nextDouble() * 0.4;
  }

  /// Shuffles the position of bubbles around the screen.
  void _shuffle() {
    startTime -= Duration(
      milliseconds:
          (this.randomValue.nextDouble() * duration.inMilliseconds).round(),
    );
  }

  /// Checks if a bubble needs to be rebuilt in the UI.
  checkIfBubbleNeedsToBeRestarted() {
    if (progress() == 1.0) {
      _restart();
    }
  }

  /// Checks if a bubble has reached the top.
  ///
  /// If the progress returns 1, then the bubble has reached the top.
  double progress() {
    return ((Duration(
                  milliseconds: DateTime.now().millisecondsSinceEpoch,
                ).inMicroseconds -
                startTime.inMicroseconds) /
            duration.inMicroseconds)
        .clamp(0.0, 1.0)
        .toDouble();
  }
}
