import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:user_management/constants/assets.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/presentation/controller/user/user_store_controller.dart';

class BalanceItem extends StatelessWidget {

  BalanceItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserStoreController userStoreController = Get.put(UserStoreController());
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 16.h, 0, 16.h),
        decoration: BoxDecoration(
          gradient: AppColors.pinkGradientButton,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Padding(
                padding: EdgeInsets.only(bottom: 3.h),
                child: Center(
                  child: Text(
                    'home_balance'.tr,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Image.asset(
                  Assets.diamondIcon,
                  height: 30.h,
                ),
                SizedBox(width: 15.w,),
                Padding(
                  padding: EdgeInsets.only(right: 5.w),
                  child: Obx(() => Text(
                    ConvertCommon().convertBalance(userStoreController.balance.value),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 28.sp,
                    ),
                  )),
                ),
                Text(
                  'Ruby',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
