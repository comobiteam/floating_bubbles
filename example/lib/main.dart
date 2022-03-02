import 'package:example/fps.dart';
import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: true,
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}

// Simple example.
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    eachFrame()
        .take(10000)
        .transform(const ComputeFps())
        .listen((fps) => print('fps: $fps'));
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.white,
          ),
        ),
        Positioned.fill(
          child: FloatingBubbles.alwaysRepeating(
            bubbleColorAlpha: 70,
            bubbleColors: [Colors.red, Colors.blue, Colors.purple],
            bubbleSpeed: Duration(seconds: 20),
            numOfOnScreenBubbles: 5,
            paintingStyle: PaintingStyle.fill,
            shape: BubbleShape.circle,
            sizeFactor: 0.2,
          ),
        ),
      ],
    );
  }
}
