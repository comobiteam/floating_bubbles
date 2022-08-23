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
    return Stack(
      alignment: Alignment.center,
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
            bubbleSpeed: Duration(seconds: 30),
            numOfBubblesOnScreen: 20,
            paintingStyle: PaintingStyle.fill,
            shape: BubbleShape.circle,
            sizeFactor: 0.15,
          ),
        ),
        Positioned(
            bottom: 20,
            child: Row(
              children: [
                ElevatedButton(
                  child: Text('Stop Bubbles'),
                  onPressed: () {},
                ),
                SizedBox(width: 50),
                ElevatedButton(
                  child: Text('Start Bubbles'),
                  onPressed: () {},
                ),
              ],
            ))
      ],
    );
  }
}
