import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';

/// Helper class for text
///
class TextUtils {

  TextUtils._();

  static TextStyle textStyle(FontWeight fw, double fontSize, {Color color = AppColors.grayCustom, TextDecoration decor = TextDecoration.none, FontStyle fontStyle = FontStyle.normal}) {
    return TextStyle(
      fontWeight: fw,
      fontSize: fontSize,
      color: color,
      decoration: decor,
      fontStyle: fontStyle,
    );
  }

  static getSizeText(BuildContext context, String text, TextStyle textStyle){
    final Size size = (TextPainter(
        text: TextSpan(text: text, style: textStyle),
        maxLines: 1,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        textDirection: TextDirection.ltr)
      ..layout())
        .size;
    return size;
  }

  static String maskAddress(String address, {required int start, required int end}) {
    return '${address.substring(0, start)}...${address.substring(end, address.length)}';
  }

}
