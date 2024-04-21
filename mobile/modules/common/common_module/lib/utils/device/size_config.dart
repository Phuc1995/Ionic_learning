import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;
  static double? blockSize;
  static bool isPortrait = true;

  static void init({required BuildContext context, double? width, double? height}) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = width ?? _mediaQueryData!.size.width;
    screenHeight = height ??  _mediaQueryData!.size.height;
    blockSizeHorizontal = screenWidth! / 100;
    blockSizeVertical = screenHeight! / 100;
    blockSize = _mediaQueryData!.orientation == Orientation.portrait ? blockSizeHorizontal : blockSizeVertical;
    isPortrait = _mediaQueryData!.orientation == Orientation.portrait;
  }
}