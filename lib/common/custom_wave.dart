
import 'package:flutter/cupertino.dart';

class WaveCustomPaint extends CustomPainter {
  Color backgroundColor;
  WaveCustomPaint({required this.backgroundColor});

  @override

    void paint(Canvas canvas, Size size) {
      var painter = Paint()
        ..color = backgroundColor
        ..strokeWidth = 1
        ..style = PaintingStyle.fill;

      var path = Path();
      var height = size.height;
      var width = size.width;


      path.moveTo(0, height);


      path.quadraticBezierTo(
          width / 6, height * 2 / 3,  // control point
          width / 3, height / 2       // end point
      );


      path.quadraticBezierTo(
          width / 2, height / 3,      // control point
          width * 2 / 3, height / 4   // end point
      );


      path.quadraticBezierTo(
          width * 5 / 6, height / 6,  // control point
          width, 0                    // end point
      );

      // Complete the shape by going around the canvas
      path.lineTo(width, height);  // bottom-right corner
      path.lineTo(0, height);      // bottom-left corner
      path.close();

      canvas.drawPath(path, painter);
    }


    @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
