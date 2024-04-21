import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:level/contants/assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:level/controllers/controllers.dart';
import 'package:level/services/level_policy_service.dart';

class LevelDetailWidget extends StatefulWidget {
  const LevelDetailWidget({Key? key}) : super(key: key);

  @override
  _LevelDetailWidgetState createState() => _LevelDetailWidgetState();
}

class _LevelDetailWidgetState extends State<LevelDetailWidget> {
  final _levelPolicyService = Modular.get<LevelPolicyService>();
  final _levelDetailController = Get.put(LevelDetailController());
  final _sharedPrefsHelper = Modular.get<SharedPreferenceHelper>();
  String storageUrl = '';

  @override
  void initState() {
    storageUrl = _sharedPrefsHelper.storageServer + '/' + _sharedPrefsHelper.bucketName + '/';
      _initDataLevel();
    super.initState();
  }

  Future<void> _initDataLevel() async {
    final data = await _levelPolicyService.getLevelPolicy();
    data.fold((l) => null, (data) => {
      _levelDetailController.listItemDetail.value = data
    });
  }
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = DeviceUtils.getWidthDevice(context) / 100;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15.w),
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "level_detail_title".tr,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17.sp,
                  color: ConvertCommon().hexToColor("#3A3A3A"),
                ),
              )),
        ),
        Container(
          margin: EdgeInsets.only(top: 20.h, bottom: 5.h),
          color: AppColors.whiteSmoke2,
          child: Row(children: [
            Container(
              height: 47.h,
              width: screenWidth * 25,
            ),
            Container(
              height: 47.h,
              width: screenWidth * 30,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "level_detail_medal".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                    color: ConvertCommon().hexToColor("#444444"),
                  ),
                ),
              ),
            ),
            Container(
              height: 47.h,
              width: screenWidth * 25,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "level_detail_armorial".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                    color: ConvertCommon().hexToColor("#444444"),
                  ),
                ),
              ),
            ),
            Container(
              height: 47.h,
              width: screenWidth * 20,
              child: Center(
                child: Text(
                  "level_detail_exp".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                    color: ConvertCommon().hexToColor("#444444"),
                  ),
                ),
              ),
            ),
          ],),
        ),
        _buildListView(screenWidth, _levelDetailController, context),
      ],
    );
  }

  Widget _buildListView(double screenWidth, LevelDetailController levelDetailController, BuildContext context) {
    return Obx(()=> ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: levelDetailController.listItemDetail.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return _itemListView(screenWidth, index, levelDetailController, context);
        }));
  }

  Widget _itemListView(double screenWidth, int index,  LevelDetailController levelDetailController, BuildContext context){
    String level = levelDetailController.listItemDetail[index].level;
    // bool isCheck = false;
    int currentExp = 0;

    String medalUrl = storageUrl + levelDetailController.listItemDetail[index].medalUrl;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
      ),
      child: Container(
        // decoration: BoxDecoration(
        //   color: Colors.black12.withOpacity(0.2),
        // ),
        color: index.isOdd ? AppColors.whiteSmoke2 : Colors.white,
        child: Row(children: [
          Obx(() =>  Container(
            margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
            height: 47.sp,
            width: screenWidth * 25,
            child: Padding(
              padding: EdgeInsets.only(left: 15.w, ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      "Lv"+level.substring(level.length - 1),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17.sp,
                          color: ConvertCommon().hexToColor("#444444")
                      ),
                    ),
                    if (_levelDetailController.minExp.value == levelDetailController.listItemDetail[index].minExp)...[
                      Image.asset(Assets.check_level),
                    ],
                  ],
                ),
              ),
            ),
          )),
          InkWell(
            child: Container(
              height: 47.h,
              width: screenWidth * 30,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.network(medalUrl)
              ),
            ),
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _buildAlertDialog(context, level.substring(level.length - 1), medalUrl, levelDetailController.listItemDetail[index].level);
                  });
              } ,
          ),
          Container(
            height: 47.h,
            width: screenWidth * 25,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.network(storageUrl + levelDetailController.listItemDetail[index].armorialUrl,
            ),
            ),
          ),
          Container(
            height: 47.h,
            width: screenWidth * 20,
            child: Center(
              child: Text(
                levelDetailController.listItemDetail[index].maxExp == null ? "> " + (levelDetailController.listItemDetail[index].minExp - 1).toString() : levelDetailController.listItemDetail[index].minExp.toString() + "-" + levelDetailController.listItemDetail[index].maxExp.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13.sp,
                  color: ConvertCommon().hexToColor("#444444"),
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],),
      ),
    );
  }

  _buildAlertDialog(BuildContext context, String level, String urlMedal, String levelKey) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 200.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'level_detail_medal'.tr + " " + "level".tr + " " + level,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18.sp,
                height: 2.h,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              width: 85.w,
                child: Image.network(urlMedal)),
            SizedBox(
              height: 1.h,
            ),
            Text(
              "${levelKey}_medal_name".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ConvertCommon().hexToColor("#8A8A8A"),
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                height: 2.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
