import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildHint extends StatefulWidget {
  @override
  _BuildHintState createState() => _BuildHintState();
}

class _BuildHintState extends State<BuildHint> {
  // shared pref object
  late SharedPreferenceHelper _sharedPrefsHelper;
  late Future<void> _initializeControllerFuture;
  var mail = ''.obs;

  @override
  initState() {
    super.initState();
    _initializeControllerFuture = Future.wait([_initSharedPrefs()]);
  }

  Future<void> _initSharedPrefs() async {
    _sharedPrefsHelper = await SharedPreferenceHelper.getInstance();
    mail.value = _sharedPrefsHelper.registeredID.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: AppColors.whiteSmoke2,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Padding(
          padding: EdgeInsets.all(15.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildHintRowStep1(),
              _buildHintRowStep2(),
            ],
          ),
        ));
  }

  Widget _buildHintRowStep1() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildIcon(Icons.check),
        Padding(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            bottom: 25.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: Text(
                  'account_complete_create_account'.tr,
                  style: TextUtils.textStyle(
                    FontWeight.w400,
                    15.sp,
                    color: AppColors.grayCustom1,
                  ),
                ),
              ),
              Obx(
                () => Container(
                  width: 260.w,
                  child: Text(
                    mail.value,
                    style: TextUtils.textStyle(
                      FontWeight.w400,
                      14.sp,
                      color: AppColors.suvaGrey,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHintRowStep2() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildIcon('2'),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Text(
                    'account_complete_verify'.tr,
                    style: TextUtils.textStyle(
                      FontWeight.w600,
                      15.sp,
                      color: AppColors.grayCustom1,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _buildListRow(
                      Icons.check,
                      'account_complete_hint_text_1'.tr,
                    ),
                    _buildListRow(
                      Icons.check,
                      'account_complete_hint_text_2'.tr,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIcon(dynamic icon) {
    return Container(
      width: 30.w,
      height: 30.h,
      child: icon is String
          ? Center(
              child: Text(
                icon,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : Icon(
              icon,
              color: Colors.white,
              size: 16.sp,
            ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.pinkGradientButton,
      ),
    );
  }

  Widget _buildListRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 5.w),
            child: Icon(
              icon,
              color: AppColors.mountainMeadow,
              size: 16.sp,
            ),
          ),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.left,
              style: TextUtils.textStyle(
                FontWeight.w400,
                14.sp,
                color: AppColors.suvaGrey,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
