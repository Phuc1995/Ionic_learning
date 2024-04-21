import 'dart:async';
import 'dart:io';

import 'package:common_module/common_module.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef AsyncCallback = Future<void> Function();

class NetworkUtil {

  static Future<bool> checkConnectivity({bool isShowMessage = true}) async {
    BuildContext context = GlobalState.navigatorKey.currentContext!;
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      //check when wifi, 4G is disabled on the device
      if (connectivityResult == ConnectivityResult.none) {
        isShowMessage ? ShowShortMessage().showTop(context: context, message: "no_network".tr) : null;
        return Future<bool>.value(false);
      } else {
        // check when wifi, 4G is enabled but have an error on the modem device or 4G is out of space
        final result = await InternetAddress.lookup(dotenv.env['LOOKUP_DOMAIN']??'google.com').timeout(Duration(seconds: 3));
        return Future<bool>.value(result.isNotEmpty && result[0].rawAddress.isNotEmpty);
      }
    } on SocketException catch (_) {
      isShowMessage ? ShowShortMessage().showTop(context: context, message: "no_network".tr) : null;
      return Future<bool>.value(false);
    } on TimeoutException catch(_){
      isShowMessage ? ShowShortMessage().showTop(context: context, message: "no_network".tr) : null;
      return Future<bool>.value(false);
    }
  }

  static Widget NoNetworkWidget({required AsyncCallback asyncCallback}) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 80.h),
              child: Image.asset("assets/images/no_connection.png"),
            ),
            Text('no_network_title'.tr, style: TextUtils.textStyle(FontWeight.w600, 20.sp),),
            SizedBox(
              height: 10.h,
            ),
            Text('no_network_content'.tr, style: TextUtils.textStyle(FontWeight.w400, 14.sp, color: AppColors.whiteSmoke7)),
            SizedBox(
              height: 15.h,
            ),
            RoundedButtonGradientWidget(
                    buttonColor: AppColors.whiteBackground,
                    onPressed: () async {
                      asyncCallback();
                    },
              border: Border.all(color: AppColors.whiteSmoke9, width: 1.w),
                    width: 160.w,
                    buttonText: 'no_network_button'.tr,
                    height: 35.h,
                    textSize: 14.sp,
                    textColor: AppColors.suvaGrey,
                  )
          ],
        ),
      ),
    );
  }

  static Widget ServerErrorWidget({AsyncCallback? asyncCallback, required String asset}) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 350.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    alignment: Alignment.topCenter,
                    image: AssetImage(
                      asset,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Text('live_server_err_text_1'.tr, style: TextUtils.textStyle(FontWeight.w600, 24.sp, color: Colors.white),),
            SizedBox(height: 15.h,),
            Text('live_server_err_text_2'.tr, style: TextUtils.textStyle(FontWeight.w400, 14.sp, color: Colors.white),),
            SizedBox(height: 15.h,),
            Text('live_server_err_text_3'.tr, style: TextUtils.textStyle(FontWeight.w700, 14.sp, color: Colors.white),),
            SizedBox(height: 15.h,),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(bottom: 350.h),
                child: RoundedButtonWidget(
                  height: 40.h,
                  width: 160.w,
                  buttonText: 'live_server_err_button'.tr,
                  buttonColor: Colors.black.withOpacity(0.0),
                  textColor: Colors.white,
                  border: Border.all(color: AppColors.whiteSmoke9, width: 1.5.w),
                  textSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  margin: EdgeInsets.symmetric(horizontal: 40.w),
                  onPressed: () async {
                    asyncCallback!();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
