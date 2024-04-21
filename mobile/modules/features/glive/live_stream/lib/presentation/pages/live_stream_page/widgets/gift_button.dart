import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_stream/constants/assets.dart';

class GiftButton extends StatelessWidget {

  final Function() onPressed;

  const GiftButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          margin: EdgeInsets.fromLTRB(20.w, 0, 17.w, 32.h),
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              // color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: new RawMaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(50)))),
            child: Image.asset(Assets.gift),
            onPressed: this.onPressed,
          )
      ),
    );
  }
}