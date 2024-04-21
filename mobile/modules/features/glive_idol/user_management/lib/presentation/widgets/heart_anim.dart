import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:common_module/common_module.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeartAnim extends StatelessWidget {
  final double top;
  final double left;
  final double opacity;

  HeartAnim(this.top, this.left, this.opacity);

  Widget build(BuildContext context) {
    final random = math.Random();
    final confetti = Container(
      child: Opacity(
        opacity: 0.95,
        child: Icon(
          Icons.favorite,
          color: AppColors.pink[700]!.withOpacity(opacity),
          size: (18 + random.nextInt(18)).toDouble().sp,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
    );
    return Positioned(
      bottom: top,
      right: left,
      child: confetti,
    );
  }
}
