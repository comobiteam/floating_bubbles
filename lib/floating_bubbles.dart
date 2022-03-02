/// ### Floating Bubbles Widget
///
/// With the `floating_bubbles` package, you can easily add bubbles
/// which float from the bottom to the top of your screen.
///
/// For example:
///
/// ```
///   return Stack(
///       children: [
///         Positioned.fill(
///           child: Container(
///           color: Colors.blue,
///          ),
///        ),
///       Positioned.fill(
///           child: FloatingBubbles.alwaysRepeating(
///           numOfOnScreenBubbles: 40,
///           bubbleColors: [Colors.white, Colors.red],
///           sizeFactor: 0.2,
///           bubbleColorAlpha: 70,
///           paintingStyle: PaintingStyle.fill,
///           shape: BubbleShape.circle,
///          ),
///       ),
///     ],
///   );
/// ```
/// This was made with the help of the `simple_animations` package.
library floating_bubbles;

export 'src/bubbles.dart';
