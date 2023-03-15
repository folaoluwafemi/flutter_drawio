part of '../toolbar_widget.dart';

class Knob extends StatelessWidget {
  final Size _size;

  const Knob({
    Key? key,
    Size? size,
  })  : _size = size ?? const Size.square(10),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            color: Color(0x1A1F2937),
            blurRadius: 6,
          ),
          BoxShadow(
            offset: Offset(0, 2),
            color: Color(0x0f1f2937),
            blurRadius: 4,
          ),
        ],
      ),
      child: CustomPaint(
        size: _size,
        painter: KnobPainter(),
      ),
    );
  }
}

class KnobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..color = Colors.white;

    final Rect rect = Rect.fromPoints(
      Offset.zero,
      Offset(size.width, size.height),
    );

    canvas.drawCircle(rect.center, size.width / 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
