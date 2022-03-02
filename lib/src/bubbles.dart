import 'dart:async';
import 'dart:math';

import 'package:floating_bubbles/src/bubble_painter.dart';
import 'package:floating_bubbles/src/bubble_animation.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

/// Used for selecting the shape of the bubble.
enum BubbleShape { circle, square, roundedRectangle }

/// Creates floating bubbles for [duration] amount of time.
///
/// If you want the floating bubble animation to repeat, then use the constructor
/// `FloatingBubbles.alwaysRepeating()`.
// ignore: must_be_immutable
class FloatingBubbles extends StatefulWidget {
  /// Shape of the bubble, selectable from the [BubbleShape] enum.
  final BubbleShape shape;

  /// The time it will take for the bubble to go from the bottom
  /// to the top of the screen.
  final Duration bubbleSpeed;

  /// Size factor of the bubble.
  ///
  /// Typically should be > 0 and < 0.5. Otherwise the bubble size will be too large.
  final double sizeFactor;

  /// Determines the width of the bubble's stroke.
  ///
  /// Is effective only if [paintingStyle] is set to [PaintingStyle.stroke].
  final double strokeWidth;

  /// Number of bubbles displayed on the screen at the same time.
  final int numOfBubblesOnScreen;

  /// Used to determine the degree of transparency of the bubble's color.
  ///
  /// Should be between 0 and 255.
  final int bubbleColorAlpha;

  /// List of colors that will randomly be applied to the bubbles.
  final List<Color> bubbleColors;

  /// Determines the bubble's style.
  ///
  /// [PaintingStyle.fill] will paint a full bubble.
  ///
  /// [PaintingStyle.stroke] will only paint the stroke of the bubble.
  final PaintingStyle paintingStyle;

  /// In case you use the `FloatingBubbles()` constructor,
  /// this will be the duration of the animation.
  int? duration;

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
          bubbleColor: widget
              .bubbleColors[randomValue.nextInt(widget.bubbleColors.length)],
          bubbleSpeed: widget.bubbleSpeed));
    }
    if (widget.duration != null && widget.duration != 0)
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
    return widget.duration != null && widget.duration == 0
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

  /// Checks whether the onscreen bubbles have to be restarted due to
  /// frame skips.
  _simulateBubbles() {
    bubbles.forEach((bubbles) => bubbles.checkIfBubbleNeedsToBeRestarted());
  }
}
