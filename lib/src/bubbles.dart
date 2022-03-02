import 'dart:async';
import 'dart:math';

import 'package:floating_bubbles/src/bubble_painter.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

import 'bubble_animation.dart';

enum BubbleShape { circle, square, roundedRectangle }

/// Creates floating bubbles for [duration] amount of time.
///
/// If you want the floating bubble animation to repeat, then use the constructor
/// `FloatingBubbles.alwaysRepeating()`.
///
/// [strokeWidth] is effective only if [paintingStyle] is set to [PaintingStyle.stroke].
// ignore: must_be_immutable
class FloatingBubbles extends StatefulWidget {
  final BubbleShape shape;
  final Duration bubbleSpeed;
  final double sizeFactor;
  final double strokeWidth;
  final int numOfBubblesOnScreen;
  final int bubbleColorAlpha;
  final List<Color> bubbleColors;
  final PaintingStyle paintingStyle;
  int? duration;

  bool get durationBool => duration != null && duration != 0;

  FloatingBubbles({
    required this.bubbleColors,
    required this.duration,
    required this.numOfBubblesOnScreen,
    required this.sizeFactor,
    this.bubbleSpeed = const Duration(seconds: 3),
    this.bubbleColorAlpha = 100,
    this.paintingStyle = PaintingStyle.fill,
    this.shape = BubbleShape.circle,
    this.strokeWidth = 0,
  })  : assert(
          sizeFactor > 0 && sizeFactor < 0.5,
          'Size factor cannot be less than 0 or greater than 0.5.',
        ),
        assert(duration != null && duration >= 0,
            'Duration should not be null or less than 0.'),
        assert(
          bubbleColorAlpha >= 0 && bubbleColorAlpha <= 255,
          'Opacity value should be between 0 and 255 inclusive.',
        );

  /// Repeatedly creates floating bubbles.
  ///
  /// If you want the floating bubble to play only for a specific amount of time,
  /// then use the constructor `FloatingBubbles()`.
  FloatingBubbles.alwaysRepeating({
    required this.bubbleColors,
    required this.numOfBubblesOnScreen,
    required this.sizeFactor,
    this.bubbleSpeed = const Duration(seconds: 3),
    this.bubbleColorAlpha = 60,
    this.paintingStyle = PaintingStyle.fill,
    this.shape = BubbleShape.circle,
    this.strokeWidth = 0,
  })  : assert(
          sizeFactor > 0 && sizeFactor < 0.5,
          'Size factor cannot be less than 0 or greater than 0.5.',
        ),
        assert(
          bubbleColorAlpha >= 0 && bubbleColorAlpha <= 255,
          'Opacity value should be between 0 and 255 inclusive.',
        ) {
    duration = 0;
  }

  @override
  _FloatingBubblesState createState() => _FloatingBubblesState();
}

class _FloatingBubblesState extends State<FloatingBubbles> {
  /// If [this] value == 0, animation is played, else animation is stopped.
  /// Value of this is never changed when the duration is zero.
  int checkToStopAnimation = 0;

  final List<BubbleAnimation> bubbles = [];

  final Random randomValue = Random();

  @override
  void initState() {
    for (int i = 0; i < widget.numOfBubblesOnScreen; i++) {
      bubbles.add(BubbleAnimation(
          randomValue: randomValue,
          bubbleColor: widget
              .bubbleColors[randomValue.nextInt(widget.bubbleColors.length)],
          bubbleSpeed: widget.bubbleSpeed));
    }
    if (widget.durationBool)
      Timer(Duration(seconds: widget.duration!), () {
        setState(() {
          checkToStopAnimation = 1;
        });
      });
    super.initState();
  }

  CustomPaint paintBubbles({required CustomPainter bubbles}) {
    return CustomPaint(
      painter: bubbles,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.durationBool
        ? LoopAnimation(
            tween: ConstantTween(1),
            builder: (context, child, value) {
              _simulateBubbles();
              return paintBubbles(
                bubbles: BubblePainter(
                  bubbles: bubbles,
                  sizeFactor: widget.sizeFactor,
                  colorAlpha: widget.bubbleColorAlpha,
                  paintingStyle: widget.paintingStyle,
                  strokeWidth: widget.strokeWidth,
                  shape: widget.shape,
                ),
              );
            },
          )
        : PlayAnimation(
            duration: checkToStopAnimation == 0
                ? Duration(seconds: widget.duration!)
                : Duration.zero,
            tween: ConstantTween(1),
            builder: (context, child, value) {
              _simulateBubbles();
              if (checkToStopAnimation == 0)
                return paintBubbles(
                  bubbles: BubblePainter(
                    bubbles: bubbles,
                    sizeFactor: widget.sizeFactor,
                    colorAlpha: widget.bubbleColorAlpha,
                    paintingStyle: widget.paintingStyle,
                    strokeWidth: widget.strokeWidth,
                    shape: widget.shape,
                  ),
                );
              else
                // Display an empty container after the animation ends.
                return Container();
            },
          );
  }

  /// Checks whether the displayed bubbles have to be restarted due to
  /// frame skips.
  _simulateBubbles() {
    bubbles.forEach((bubbles) => bubbles.checkIfBubbleNeedsToBeRestarted());
  }
}
