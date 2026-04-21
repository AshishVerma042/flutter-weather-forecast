import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SlantedCard extends StatelessWidget {
  const SlantedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(Get.width, 150),
      painter: SlantedCardPainter(),
    );
  }
}



class SlantedCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF6D28D9), Color(0xFF312E81)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final radius = 16.0;
    final topRightOffset = size.height * 0.37;

    final path = Path()
      ..moveTo(0, radius)
      ..quadraticBezierTo(0, 0, radius, 0) // Top-left corner
      ..lineTo(size.width - radius, topRightOffset-3) // Slanted top line
      ..quadraticBezierTo(
        size.width,
        topRightOffset,
        size.width,
        topRightOffset + radius,
      ) // Smooth top-right corner
      ..lineTo(size.width, size.height - radius)
      ..quadraticBezierTo(
        size.width,
        size.height,
        size.width - radius,
        size.height,
      ) // Bottom-right
      ..lineTo(radius, size.height)
      ..quadraticBezierTo(
        0,
        size.height,
        0,
        size.height - radius,
      ) // Bottom-left
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}