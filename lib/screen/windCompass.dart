import 'package:flutter/material.dart';
import 'dart:math';

class WindCompass extends StatelessWidget {
  final double size;
  final double borderWidth;
  final int stripeCount;

  final double windDegree;

  final double windKph;
  final String windDir;

  const WindCompass({
    super.key,
    this.size = 120,
    this.borderWidth = 8,
    this.stripeCount = 250,
    required this.windDegree,

    required this.windKph,
    required this.windDir,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: WindCompassPainter(
        borderWidth: borderWidth,
        stripeCount: stripeCount,
        windDegree: windDegree,

        windKph: windKph,
        windDir: windDir,
      ),
    );
  }
}

class WindCompassPainter extends CustomPainter {
  final double borderWidth;
  final int stripeCount;
  final double windDegree;

  final double windKph;
  final String windDir;

  WindCompassPainter({
    required this.borderWidth,
    required this.stripeCount,
    required this.windDegree,
    required this.windKph,
    required this.windDir,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - borderWidth / 2;
    final sweep = 2 * pi / stripeCount;

    // Draw zebra ring
    for (int i = 0; i < stripeCount; i++) {
      final paint = Paint()
        ..color = i.isEven ? Colors.transparent : Colors.white54
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), i * sweep, sweep, false, paint);
    }

    // Draw cardinal directions (N, E, S, W)
    const dirs = [ 'E', 'S', 'W','N'];
    const angles = [0, 90, 180, 270];
    final tickPaint = Paint()..color = Colors.white..strokeWidth = 2;

    for (int i = 0; i < 4; i++) {
      final a = (angles[i] - 90) * pi / 180;
      final start = Offset(center.dx + radius * cos(a), center.dy + radius * sin(a));
      final end = Offset(center.dx + (radius - 10) * cos(a), center.dy + (radius - 10) * sin(a));
      canvas.drawLine(start, end, tickPaint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: dirs[i],
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final labelRadius = radius - borderWidth +10;
      final offset = Offset(
        center.dx + labelRadius * cos(a) - textPainter.width / 2,
        center.dy + labelRadius * sin(a) - textPainter.height / 2,
      );
      textPainter.paint(canvas, offset);
    }

    // Draw wind arrow
    final windAngle = (windDegree - 90) * pi / 180;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(windAngle);

    final arrowLength = radius - borderWidth + 20;
    final arrowPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Arrowhead
    final Path arrowHead = Path();
    arrowHead.moveTo(0, -arrowLength+24);
    arrowHead.lineTo(-5, -arrowLength + 36);
    arrowHead.lineTo(5, -arrowLength + 36);
    arrowHead.close();
    canvas.drawPath(arrowHead, arrowPaint);

    // Shaft (half length)
    final shaftPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, -arrowLength +30),
      Offset(0, -arrowLength + 12 + 36),
      shaftPaint,
    );

    // Tail circle (hollow)
    final tailOffset = arrowLength / 1;
    final tailCirclePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(0, tailOffset-26), 3, tailCirclePaint);

    // Tail extension line (optional)
    final tailLinePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, tailOffset - 30),
      Offset(0, tailOffset - 45),
      tailLinePaint,
    );

    canvas.restore();

    // Draw wind speed text
    final sp = '${windKph.toStringAsFixed(1)} Kph \n    $windDir ';
    final txtSp = TextPainter(
      text: TextSpan(
        text: sp,
        style: const TextStyle(color: Colors.white, fontSize: 14),

      ),
      textDirection: TextDirection.ltr,
    )..layout();
    txtSp.paint(canvas, center + const Offset(-30, -10));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
