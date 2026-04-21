import 'package:flutter/material.dart';
import 'dart:math';

class RotatingButtonOverZebraRing extends StatefulWidget {
  const RotatingButtonOverZebraRing({super.key});

  @override
  State<RotatingButtonOverZebraRing> createState() => _RotatingButtonOverZebraRingState();
}

class _RotatingButtonOverZebraRingState extends State<RotatingButtonOverZebraRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final double ringSize = 120;
  final double borderWidth = 12;
  final int stripeCount = 120;
  final double buttonSize = 18;
  final double radiusOffset = 54;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ringSize,
      height: ringSize,
      child: Stack(
        children: [
          // Zebra ring background
          ZebraRing(
            size: ringSize,
            borderWidth: borderWidth,
            stripeCount: stripeCount,
          ),

          // Rotating button with continuous trail
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              const int trailCount = 8; // More trail pieces
              const double trailFade = 0.99;
              const double trailStep = 0.01; // Small step = less space between trail segments

              final double buttonWidth = 5.0;
              final double buttonHeight = buttonSize;

              final List<Widget> trail = [];

              for (int i = 1; i <= trailCount; i++) {
                final double trailValue = (_controller.value - i * trailStep) % 1.0;
                final double trailAngle = 2 * pi * trailValue;

                final Offset offset = Offset(
                  radiusOffset * cos(trailAngle),
                  radiusOffset * sin(trailAngle),
                );

                trail.add(
                  Transform.translate(
                    offset: offset,
                    child: Transform.rotate(
                      angle: trailAngle + pi / 2,
                      child: Opacity(
                        opacity: trailFade - i * (trailFade / trailCount),
                        child: Container(
                          width: borderWidth, // match ring thickness
                          height: borderWidth,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(borderWidth / 2),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }

              final double angle = 2 * pi * _controller.value;
              final Offset offset = Offset(
                radiusOffset * cos(angle),
                radiusOffset * sin(angle),
              );

              return Center(
                child: SizedBox(
                  width: ringSize,
                  height: ringSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ...trail,
                      Transform.translate(
                        offset: offset,
                        child: Transform.rotate(
                          angle: angle + pi / 2,
                          child: SizedBox(
                            width: buttonWidth,
                            height: buttonHeight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(buttonWidth / 2),
                                ),
                                backgroundColor: Colors.white,
                                shadowColor: Colors.black,
                                elevation: 10,
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () => debugPrint("Rotating Rect Button Pressed"),
                              child: null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Zebra ring painter
class ZebraRing extends StatelessWidget {
  final double size;
  final double borderWidth;
  final int stripeCount;

  const ZebraRing({
    super.key,
    this.size = 200,
    this.borderWidth = 20,
    this.stripeCount = 120,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: ZebraRingPainter(
        borderWidth: borderWidth,
        stripeCount: stripeCount,
      ),
    );
  }
}

class ZebraRingPainter extends CustomPainter {
  final double borderWidth;
  final int stripeCount;

  ZebraRingPainter({
    required this.borderWidth,
    required this.stripeCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - borderWidth / 2;
    final double sweepAngle = 2 * pi / stripeCount;

    for (int i = 0; i < stripeCount; i++) {
      final paint = Paint()
        ..color = i.isEven ? Colors.transparent : Colors.white54
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * sweepAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
