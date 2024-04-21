import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/constants/assets.dart';


class RubyCount extends StatelessWidget {
  final String roomId;
  const RubyCount({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int ruby = 0;
    return StreamBuilder(
      stream: FirebaseStorage.getRuby(this.roomId),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && !snapshot.hasError && snapshot.data.snapshot.value != null) {
          ruby = snapshot.data.snapshot.value;
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              constraints: new BoxConstraints(
                minWidth: 50.0.w,
              ),
              padding: EdgeInsets.only(right: 5.w),
              height: 25.h,
              decoration: BoxDecoration(
                  color: AppColors.wildWatermelon.withOpacity(0.6),
                  borderRadius: BorderRadius.all(Radius.circular(40.r))),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(4.w, 4.h, 4.w, 4.h),
                    decoration: BoxDecoration(
                        color: AppColors.grayCustom1.withOpacity(0.4),
                        borderRadius: BorderRadius.all(Radius.circular(40.r))),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Image.asset(
                        Assets.diamondIcon,
                      ),
                    ),
                  ),
                  Text(
                    ruby.toString(),
                    style: TextUtils.textStyle(FontWeight.w400, 15.sp, color: Colors.white),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
