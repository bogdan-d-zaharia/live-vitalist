import 'package:flutter/widgets.dart';

class DottedLine extends StatelessWidget {
  const DottedLine({
    required this.dotDiameter,
    required this.dotSpacing,
    required this.color,
    super.key,
  });

  final double dotDiameter;
  final double dotSpacing;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: dotDiameter,
      child: CustomPaint(
        size: Size(1000.0, 100.0),
        painter: DottedLinePainter(
          dotDiameter: dotDiameter,
          dotSpacing: dotSpacing,
          color: color,
        ),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  const DottedLinePainter({
    required this.dotDiameter,
    required this.dotSpacing,
    required this.color,
  });

  final double dotDiameter;
  final double dotSpacing;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    for (double i = 0.0; i < size.width; i += dotDiameter + dotSpacing) {
      canvas.drawCircle(Offset(i, dotDiameter / 2.0), dotDiameter / 2.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
