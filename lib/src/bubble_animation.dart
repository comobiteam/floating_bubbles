import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum OffsetProps { x, y }

class BubbleAnimation {
  /// The time it will take for the bubble to go from the bottom
  /// to the top of the screen.
  final Duration bubbleSpeed;

  /// Color of the bubble, randomly selected from a List<Color>.
  final Color bubbleColor;

  BubbleAnimation({
    required this.bubbleColor,
    this.bubbleSpeed = const Duration(seconds: 3),
  }) {
    _restart();
    _shuffle();
  }

  final Random randomValue = Random();
  late double size;
  late Duration duration;
  late Duration startTime;
  late MovieTween tween;

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

    duration = bubbleSpeed +
        Duration(
          milliseconds: randomValue.nextInt(6000),
        );

    size = 0.2 + randomValue.nextDouble() * 0.4;

    startTime = Duration(
      milliseconds: DateTime.now().millisecondsSinceEpoch,
    );

    tween = MovieTween()
      ..tween(
        OffsetProps.x,
        Tween(
          begin: startPosition.dx,
          end: endPosition.dx,
        ),
      )
      ..tween(
        OffsetProps.y,
        Tween(
          begin: startPosition.dy,
          end: endPosition.dy,
        ),
      );
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
