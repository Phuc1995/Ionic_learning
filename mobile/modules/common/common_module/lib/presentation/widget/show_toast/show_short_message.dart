import 'package:another_flushbar/flushbar.dart';
import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';

class ShowShortMessage {
  Widget show({required BuildContext context, required String message, int second = 3, Color? backgroundColor, Color? messageColor}) {
    if (message.isNotEmpty) {
      Future.delayed(Duration(milliseconds: 0), () {
        if (message.isNotEmpty) {
          Flushbar(
            forwardAnimationCurve: Curves.decelerate,
            reverseAnimationCurve: Curves.easeOut,
            positionOffset: 20,
            duration: Duration(seconds: second),
            message: message,
            messageColor: messageColor ?? Colors.white,
            backgroundColor: backgroundColor ?? Colors.grey.shade500,
          )..show(context);
        }
      });
    }
    return SizedBox.shrink();
  }

  Widget showTop({required BuildContext context, required String message, Color? messageColor, Color? backgroundColor, int duration=3}) {
    if (message.isNotEmpty) {
      Future.delayed(Duration(milliseconds: 0), () {
        if (message.isNotEmpty) {
          Flushbar(
            forwardAnimationCurve: Curves.decelerate,
            reverseAnimationCurve: Curves.easeOut,
            positionOffset: 20,
            duration: Duration(seconds: duration),
            message: message,
            messageColor: messageColor ?? Colors.white,
            backgroundColor: backgroundColor ?? AppColors.pinkLiveButtonCustom,
            flushbarPosition: FlushbarPosition.TOP,
          )..show(context);
        }
      });
    }
    return SizedBox.shrink();
  }
}
