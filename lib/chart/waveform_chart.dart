import 'package:flutter/material.dart';

const barGap = 15;

class WaveformChart extends StatelessWidget {
  final List<double> data;

  const WaveformChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: CustomPaint(
          size: Size(width * 20, double.infinity),
          painter: _Painter(data),
        ),
      ),
      // ),
    );
  }
}

class _Painter extends CustomPainter {
  final List<double> data;

  final linePaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.black
    ..strokeWidth = 5.0
    ..isAntiAlias = true;

  _Painter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    for (var i = 0; i < data.length; i++) {
      final x = i.toDouble() * barGap;
      final halfValue = data[i] / 2;
      canvas.drawLine(Offset(x, y), Offset(x, y - halfValue), linePaint);
      canvas.drawLine(Offset(x, y), Offset(x, y + halfValue), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _Painter oldDelegate) =>
      oldDelegate.data != data;
}
