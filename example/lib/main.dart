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
    // eachFrame()
    //     .take(10000)
    //     .transform(const ComputeFps())
    //     .listen((fps) => print('fps: $fps'));
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.white,
          ),
        ),
        Positioned.fill(
          child: FloatingBubbles.alwaysRepeating(
            numOfOnScreenBubbles: 5,
            bubbleColors: [Colors.red, Colors.blue, Colors.purple],
            sizeFactor: 0.2,
            bubbleColorAlpha: 70,
            paintingStyle: PaintingStyle.fill,
            bubbleSpeed: Duration(seconds: 20),
            shape: BubbleShape.circle, //This is the default
          ),
        ),
      ],
    );
  }
}
