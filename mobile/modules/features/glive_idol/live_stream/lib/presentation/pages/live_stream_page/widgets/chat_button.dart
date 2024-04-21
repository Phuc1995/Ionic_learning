import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_stream/constants/assets.dart';
import 'package:user_management/constants/custom_icons.dart';

class ChatButton extends StatelessWidget {

  final Function() onPressed;

  const ChatButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(20.w, 0, 0, 32.h),
        width: 50.h,
        height: 50.h,
        child: InkWell(
          onTap: onPressed,
          child: Image.asset(Assets.chat),
        )
    );
  }
}