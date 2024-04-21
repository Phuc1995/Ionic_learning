import 'package:common_module/common_module.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_stream/constants/assets.dart';
import 'package:live_stream/controllers/camera_live_controller.dart';

class EndLiveButton extends StatelessWidget {

  final Function? onCancel;

  final Function? onConfirm;

  final CameraLiveController? cameraLiveController;

  const EndLiveButton({
    Key? key,
    this.onCancel,
    this.onConfirm,
    this.cameraLiveController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: IconButton(
        color: Colors.white70,
        icon: Image.asset(Assets.end_live),
        iconSize: 32.sp,
        onPressed: () => {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return _buildDialog(context);
            },
          )
        },
      ),
    );
  }

  Widget _buildDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(20)))),
      contentPadding: EdgeInsets.only(top: 32.0.h),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              'live_close_live_confirm'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18.sp,
                height: 2.h,
              ),
            ),
          )
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10.w, top: 20.h, bottom: 20.h),
              width: MediaQuery.of(context).size.width * 0.3,
              child: RoundedButtonGradientWidget(
                textSize: 16.sp,
                buttonText: 'hot_idol_cancel_btn'.tr,
                buttonColor: AppColors.darkGradientBackground,
                textColor: Colors.black,
                width: double.infinity,
                height: 36.h,
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onCancel != null) {
                    onCancel!();
                  }
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 5.w, top: 20.h, bottom: 20.h, right: 10.w),
              width: MediaQuery.of(context).size.width * 0.3,
              child: RoundedButtonGradientWidget(
                textSize: 14.sp,
                buttonText: 'button_confirm'.tr,
                buttonColor: AppColors.pinkGradientButton,
                textColor: Colors.white,
                width: double.infinity,
                height: 36.h,
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onConfirm != null) {
                    onConfirm!();
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
