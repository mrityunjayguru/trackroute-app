import 'package:flutter/material.dart';

class MarkerPainter extends CustomPainter {
  final String title;
  final String subtitle;

  MarkerPainter(this.title, this.subtitle);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Colors.white;

    // Draw rounded rectangle background
    final RRect roundedRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(10),
    );
    canvas.drawRRect(roundedRect, paint);

    // Text Painter for Title
    final textPainterTitle = TextPainter(
      text: TextSpan(
        text: title,
        style: TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainterTitle.layout(minWidth: 0, maxWidth: size.width - 20);
    textPainterTitle.paint(canvas, Offset(10, 20));

    // Text Painter for Subtitle
    final textPainterSubtitle = TextPainter(
      text: TextSpan(
        text: subtitle,
        style: TextStyle(color: Colors.black, fontSize: 30),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainterSubtitle.layout(minWidth: 0, maxWidth: size.width - 20);
    textPainterSubtitle.paint(canvas, Offset(10, 55));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
