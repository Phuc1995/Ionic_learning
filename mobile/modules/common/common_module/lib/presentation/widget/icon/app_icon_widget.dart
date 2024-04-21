import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppIconWidget extends StatelessWidget {
  final image;
  final double size;
  final double height;

  const AppIconWidget({
    Key? key,
    this.image,
    this.size = 0,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        image,
        height: this.height,
      ),
    );
  }
}
