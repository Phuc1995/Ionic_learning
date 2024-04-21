import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:payment/contants/assets.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RechargeCryptoWCWidget extends StatelessWidget {
  const RechargeCryptoWCWidget(
      {Key? key,
        required this.uri,})
      : super(key: key);
  final String uri;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      margin: EdgeInsets.only(top: 40.h, bottom: 40.h),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(color: Colors.black54, blurRadius: 10),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 20.h),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 32.h,
                  child: Image.asset(Assets.walletConnectIcon),
                ),
                SizedBox(width: 4.w,),
                Text('WalletConnect',
                  style: TextUtils.textStyle(FontWeight.bold, 28.sp),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Scan QR code with a WalletConnect wallet',
                  style: TextUtils.textStyle(FontWeight.w400, 16.sp, color: AppColors.suvaGrey),
                ),
                SizedBox(height: 12.h,),
                QrImage(data: uri, size: 300.h,),
                SizedBox(height: 12.h,),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.r),
                    border: Border.all(
                      color: Color(0xFFE1E1E1),
                    ),
                  ),
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(TextUtils.maskAddress(uri, start: 10, end: uri.length - 10),
                          style: TextUtils.textStyle(FontWeight.w500, 20.sp, color: AppColors.pink[500]!),),
                        SizedBox(width: 5.w,),
                        Image.asset(Assets.copy, width: 20.w, height: 20.h,),
                      ],
                    ),
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: uri)).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              'home_copied'.tr,
                              style: TextUtils.textStyle(FontWeight.w500, 19.sp,
                                  color: Colors.white),
                            )));
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
