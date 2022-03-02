import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:floating_bubbles/src/bubble_animation.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class BubblePainter extends CustomPainter {
  final BubbleShape shape;
  final double sizeFactor;
  final double strokeWidth;
  final int colorAlpha;
  final List<BubbleAnimation> bubbles;
  final PaintingStyle paintingStyle;

  BubblePainter({
    required this.bubbles,
    required this.colorAlpha,
    required this.paintingStyle,
    required this.shape,
    required this.sizeFactor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    bubbles.forEach((bubble) {
      final progress = bubble.progress();
      final MultiTweenValues animation = bubble.tween.transform(progress);
      final position = Offset(
        animation.get<double>(OffsetProps.x) * size.width,
        animation.get<double>(OffsetProps.y) * size.height,
      );
      final bubbleColor = bubble.bubbleColor.withAlpha(colorAlpha);
      if (shape == BubbleShape.circle)
        canvas.drawCircle(
          position,
          size.width * sizeFactor * bubble.size,
          paint..color = bubbleColor,
        );
      else if (shape == BubbleShape.square)
        canvas.drawRect(
          Rect.fromCircle(
            center: position,
            radius: size.width * sizeFactor * bubble.size,
          ),
          paint..color = bubbleColor,
        );
      else {
        Rect rect() => Rect.fromCircle(
              center: position,
              radius: size.width * sizeFactor * bubble.size,
            );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            rect(),
            Radius.circular(size.width * sizeFactor * bubble.size * 0.5),
          ),
          paint..color = bubbleColor,
        );
      }
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
