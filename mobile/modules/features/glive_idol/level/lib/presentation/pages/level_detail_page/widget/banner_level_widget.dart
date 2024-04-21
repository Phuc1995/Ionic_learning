import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:level/constants/constants.dart';
import 'package:level/controllers/controllers.dart';
import 'package:level/presentation/pages/level_detail_page/widget/rectangular_slider_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/constants/font_family.dart';

class BannerLevelWidget extends StatefulWidget {
  const BannerLevelWidget({Key? key}) : super(key: key);

  @override
  _BannerLevelWidgetState createState() => _BannerLevelWidgetState();
}

class _BannerLevelWidgetState extends State<BannerLevelWidget> {
  LevelDetailController _levelDetailController = Get.put(LevelDetailController());
  late final String storageUrl;
  late SharedPreferenceHelper _sharedPrefsHelper;

  @override
  void initState() {
    Future.wait([
      _initSharedPrefs(),
      _levelDetailController.refreshIdolExperience(context),
    ]);
    super.initState();
  }

  Future<void> _initSharedPrefs() async {
    _sharedPrefsHelper = await SharedPreferenceHelper.getInstance();
    storageUrl = _sharedPrefsHelper.storageServer + '/' + _sharedPrefsHelper.bucketName + '/';
    _levelDetailController.storageUrl.value = storageUrl;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = DeviceUtils.getWidthDevice(context) / 100;
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomRight,
          child: _buildsSquareProgress(),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: _buildArmorial(screenWidth),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: _buildTagLevel(),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: _buildTextLevel(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _buildSlider(),
        ),
      ],
    );
  }

  Widget _buildSlider() {
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 30.h),
      height: 45.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(()=>
              SliderTheme(
            data: SliderThemeData(
                trackHeight: 6.h,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: ScreenUtil().radius(7)),
                overlayShape: RoundSliderOverlayShape(overlayRadius: ScreenUtil().radius(10)),
                showValueIndicator: ShowValueIndicator.always,
                activeTrackColor: Colors.white,
                thumbColor: Colors.white,
                inactiveTickMarkColor: Colors.white,

                //custom label
                valueIndicatorColor: Colors.white,
                valueIndicatorShape:
                RectangularSliderIndicator(),
                valueIndicatorTextStyle: TextStyle(
                    color: ConvertCommon().hexToColor("#C8124D"),
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp)),
            child: Slider(
              value: _getValue(),
              min: double.parse(_levelDetailController.minExp.value.toString()),
              max: double.parse(_levelDetailController.maxExp.value.toString()),
              divisions: 100,
              label: labelSlider(),
              onChanged: (double value) {
                // setState(() {
                // });
              },
            ),
          ),
      ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 18.h,
                width: 44.w,
                decoration: BoxDecoration(
                  color: ConvertCommon().hexToColor("#C14666"),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                margin: EdgeInsets.only(left: 3.w, top: 2.h),
                child: Obx(() => Center(
                    child: Text(
                      "Lv."+_levelDetailController.rankLevel.value,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: FontFamily.inter,
                          fontSize: 12.sp,
                          color: Colors.white),
                    ))),
              ),
              Obx(() => Container(
                margin: EdgeInsets.only(right: 10.w),
                child: Text(
                  '${_levelDetailController.currentExp}/${_levelDetailController.maxExp}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500),
                ),
              ))

            ],
          ),
        ],
      ),
    );
  }

  String labelSlider(){
    double expAtLevel = double.parse(_levelDetailController.currentExp.value.toString()) - double.parse(_levelDetailController.minExp.value.toString());
    double rankAtLevel = double.parse(_levelDetailController.maxExp.value.toString()) - (double.parse(_levelDetailController.minExp.value.toString()));
    double result = (expAtLevel/rankAtLevel) * 100;
    return result.toStringAsFixed(2)+ "%";
  }

  Widget _buildArmorial(double scale) {
    return Obx(() => _levelDetailController.medalUrl.value == '' ? Container() :Container(
      width: scale * 30,
      height: 131.h,
      child: Image.network(_levelDetailController.medalUrl.value, scale: 0.1),
    ));
  }

  Widget _buildTagLevel() {
    return Container(
      margin: EdgeInsets.only(top: 93.h),
      height: 50.h,
      child: Image.asset(
        Assets.tag_level,
      ),
    );
  }

  Widget _buildsSquareProgress() {
    return Container(
      height: 190.h,
      decoration: BoxDecoration(
        gradient: AppColors.pinkGradientButton,
        borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(10))),
      ),
    );
  }

  Widget _buildTextLevel() {
    return Obx(() =>       Container(
      margin: EdgeInsets.only(top: 115.h),
      height: 50.h,
      child: Text(
        _levelDetailController.level.value.toUpperCase(),
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
          color: ConvertCommon().hexToColor("#BD0D46"),
        ),
      ),
    ));
  }

  double _getValue() {
    return double.parse(_levelDetailController.currentExp.value.toString()) > double.parse(_levelDetailController.maxExp.value.toString()) ? double.parse(_levelDetailController.maxExp.value.toString()) : double.parse(_levelDetailController.currentExp.value.toString());
  }

}


