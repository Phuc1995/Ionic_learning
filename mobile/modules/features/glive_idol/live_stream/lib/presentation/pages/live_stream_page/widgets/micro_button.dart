import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_stream/constants/assets.dart';
import 'package:user_management/constants/custom_icons.dart';

class MicroButton extends StatelessWidget {
  final bool isMute;
  final Function() onPressed;

  const MicroButton({
    Key? key,
    required this.onPressed,
    this.isMute = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 20.w, bottom: 32.h),
        width: 50.h,
        height: 50.h,
        // decoration: BoxDecoration(
        //     shape: BoxShape.rectangle,
        //     color: isMute ? Colors.red : Colors.white.withOpacity(0.5),
        //     borderRadius: BorderRadius.all(Radius.circular(12))),
        child: InkWell(
          onTap: onPressed,
          child: Image.asset(isMute ? Assets.mute : Assets.unmute),
        )
        // child: GestureDetector(
        //   child: IconButton(
        //       color: isMute ? Colors.white : Colors.black87,
        //       icon: isMute
        //           ? new Icon(Icons.mic_off)
        //           : new Icon(Icons.mic_none),
        //       onPressed: onPressed
        //   ),
        // )
    );
  }
}