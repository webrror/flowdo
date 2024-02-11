
import 'package:flowdo/common/constants/constants.dart';
import 'package:flutter/material.dart';

class CornerTrianglePainter extends CustomPainter {
  // Define properties
  final Color color;
  final Corner corner; // TopLeft, TopRight, BottomLeft, BottomRight

  CornerTrianglePainter({
    required this.color,
    required this.corner,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create a paint object
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Define path based on corner
    final path = Path();
    switch (corner) {
      case Corner.topLeft:
        path.moveTo(0, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, size.height);
        break;
      case Corner.topRight:
        path.moveTo(size.width, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height);
        break;
      case Corner.bottomLeft:
        path.moveTo(0, size.height);
        path.lineTo(size.width, size.height);
        path.lineTo(0, 0);
        break;
      case Corner.bottomRight:
        path.moveTo(size.width, size.height);
        path.lineTo(0, size.height);
        path.lineTo(size.width, 0);
        break;
    }

    // Close the path and draw it on canvas
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return (oldDelegate as CornerTrianglePainter).color != color;
  }
}