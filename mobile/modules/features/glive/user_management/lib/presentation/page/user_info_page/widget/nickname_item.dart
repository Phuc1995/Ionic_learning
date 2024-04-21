import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/constants/assets.dart';

class NicknameItem extends StatelessWidget {
  final String uuid;
  final String? nickname;
  final VoidCallback onPressed;

  const NicknameItem({
    Key? key,
    required this.uuid,
    required this.nickname,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: nickname != null && nickname!.isNotEmpty
          ? _buildNickName(context)
          : RoundedButtonWidget(
              height: 32.h,
              buttonText: 'home_nickname'.tr + ": ${uuid.shortUuid()}",
              buttonColor: AppColors.wildWatermelon,
              textColor: Colors.white,
              textSize: 10.sp,
              margin: EdgeInsets.symmetric(horizontal: 5.w),
              icon: Icons.edit,
              onPressed: this.onPressed,
            ),
    );
  }

  Widget _buildNickName(BuildContext context) {
    SizeConfig.init(context: context);
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Container(
        width: SizeConfig.blockSizeHorizontal! * 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "${'home_nickname'.tr} : ",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
              style: TextStyle(
                color: AppColors.suvaGrey,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            Flexible(
              // width: 20 * blockSizeVertical,
              child: Text(
                "${nickname}",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: true,
                style: TextStyle(
                  color: AppColors.suvaGrey,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: nickname!)).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                    'home_copied'.tr,
                    style: TextUtils.textStyle(FontWeight.w500, 19.sp,
                        color: Colors.white),
                  )));
                });
              },
              child: Container(
                width: 20.w,
                height: 20.h,
                margin: EdgeInsets.only(left: 5.w),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(Assets.copy)),
                ),
              ),
              ),
          ],
        ),
      ),
    );
  }
}
