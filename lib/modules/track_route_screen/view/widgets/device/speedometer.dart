import 'package:flutter/material.dart';
import 'dart:math';

import 'package:track_route_pro/config/theme/app_textstyle.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../../../../utils/utils.dart';

class SpeedometerWidget extends StatelessWidget {
  final String speed; // e.g., 110
  final double distance; // e.g., 99999
  final Color color; // e.g., 99999
  const SpeedometerWidget({
    super.key,
    required this.speed,
    required this.distance,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.height * 0.15,
      height: MediaQuery.of(context).size.height * 0.15,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              spreadRadius: 0,
              color: const Color(0xff000000).withOpacity(0.25),
              offset: Offset(0, 0),
            ),
          ],
        color: Colors.black,
        border: Border.all(color: AppColors.white, width: 5),
        shape: BoxShape.circle

      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(124, 124),
            painter: SpeedometerPainter(Utils.parseDouble(data: speed) / 180, color), // 180 is max speed
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10,),
              Text(
                speed,
                style: AppTextStyles(context).display32W600.copyWith(color: color),
              ),
               Text(
                "KM/H",
                style:  AppTextStyles(context).display8W600.copyWith(color: AppColors.white),
              ),
              const SizedBox(height: 8),
            ],
          )
        ],
      ),
    );
  }
}

class SpeedometerPainter extends CustomPainter {
  final double percentage;
  final Color color;

  SpeedometerPainter(this.percentage, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint baseCircle = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final Paint backgroundArcPaint = Paint()
      ..color = AppColors.color_434345 // grey color for background arc
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint arcPaint = Paint()
      ..color = color
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);

    // Draw background circle
    canvas.drawCircle(center, radius, baseCircle);

    // Draw arc from 135° to 45°
    final startAngle = 3 * pi / 4;
    final sweepAngle = 3 * pi / 2 * percentage;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius-10),
      startAngle,
      3 * pi / 2,
      false,
      backgroundArcPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 10),
      startAngle,
      sweepAngle.clamp(0, 3 * pi / 2),
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
