import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageButtonWidget extends StatelessWidget {
  final GestureTapCallback onPressed;
  final AssetImage image;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  const ImageButtonWidget(
      {Key? key,
      required this.onPressed,
      required this.image,
      this.margin,
        required this.width ,
        required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          margin: margin,
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
                image: image,
                fit: BoxFit.fill
              ),
            )
          ),
    );
  }
}
