import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_stream/constants/assets.dart';
import 'package:live_stream/controllers/live_stream_controller.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class GiftHistoryWidget extends StatelessWidget {
  final String storageUrl;
  const GiftHistoryWidget({Key? key, required this.storageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LiveStreamController liveController = Get.put(LiveStreamController());
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InkWell(
            onTap: (){
              _showGitHistory(liveController);
            },
            child: Container(
              width: 30.w,
              margin: EdgeInsets.only(top: 25.h, right: 5.w),
              child: Image.asset(Assets.gift_icon, height: 25.h,),
            ),
          ),
          Container(
            child: Stack(
              children: [
                Obx(() => Visibility(
                  visible: !liveController.isShowGiftHistory.value,
                  child: InkWell(
                    onTap: (){
                      _showGitHistory(liveController);
                    },
                    child: Container(
                      width: 75.w,
                      height: 20,
                      decoration: BoxDecoration(
                          gradient: AppColors.backgroundLoadingGradient,
                          borderRadius: BorderRadius.circular(20.r)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("live_gift".tr, style: TextUtils.textStyle(FontWeight.w500, 10.sp, color: Colors.white),),
                          Icon(Icons.arrow_drop_down_outlined, color: Colors.white, size: 16.sp,),
                        ],
                      ),
                    ),
                  ),
                )),
                Obx(() => Visibility(
                    visible: liveController.isShowGiftHistory.value,
                    child: Container(
                      height: 400.h,
                      width: 165.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: (){
                              _showGitHistory(liveController);
                            },
                            child: Container(
                              height: 35.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: AppColors.backgroundLoadingGradient,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(5.r)),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 12.w),
                                  child: Text("live_list_gift".tr, style: TextUtils.textStyle(FontWeight.w600, 13.sp, color: Colors.white),),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              _showGitHistory(liveController);
                            },
                            child: Container(
                              height: 15.h,
                              width: double.infinity,
                              color: AppColors.wildWatermelon2,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 5.w),
                                  child: Icon(Icons.arrow_drop_down_outlined, color: Colors.white, size: 16.sp,),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: ScrollablePositionedList.builder(
                                initialAlignment: liveController.giftHistory.length < 9 ? 1.h : -1.h,
                                initialScrollIndex: liveController.giftHistory.length,
                                reverse: true,
                                scrollDirection: Axis.vertical,
                                itemCount: liveController.giftHistory.length,
                                itemBuilder: (BuildContext context, int index){
                                  return _buildListTitleItem(liveController, index);
                                }),
                          )
                        ],
                      ),
                    ))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTitleItem(LiveStreamController liveController, int index){
    String quantity = "";
    if(int.parse(liveController.giftHistory[index].quantity) > 1){
      quantity = "x${liveController.giftHistory[index].quantity}";
    }
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7)
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: AvataCommon(width: 30.w, height: 30.h, color: AppColors.pink1, avatarUrl: storageUrl + liveController.giftHistory[index].userImage, shape: BoxShape.circle, padding: 0,),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Container(
                        padding: EdgeInsets.only(top: 5.h),
                        width: 75.w,
                        child: Text(liveController.giftHistory[index].userName, style: TextUtils.textStyle(FontWeight.w500, 10.sp, color: AppColors.yellow1), overflow: TextOverflow.ellipsis,)),
                    Container(
                        width: 75.w,
                        child: Text("live_give_gift".tr + " " +liveController.giftHistory[index].giftName, style: TextUtils.textStyle(FontWeight.w300, 9.sp, color: Colors.white,), overflow: TextOverflow.ellipsis)),
                    Visibility(
                      visible: quantity.toString() != "",
                      child: Container(
                        width: 75.w,
                        child: Text(quantity.toString(), style: TextUtils.textStyle(FontWeight.w300, 9.sp, color: Colors.white,), overflow: TextOverflow.ellipsis)),
                    ),
                ],
              ),
              Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.only(right: 5.w, top: 5.h),
                child: Image.network(storageUrl + liveController.giftHistory[index].giftImage, height: 30.h, width: 30.w,),
              ),
            ),
            ],
          ),
          SizedBox(height: 5.h,),
          Divider(height: 0.75.h, color: AppColors.gainsboro, indent: 6.w, endIndent: 10.w,),
        ],
      ),
    );

  }

  void _showGitHistory(LiveStreamController liveController){
    liveController.isShowGiftHistory.value = !liveController.isShowGiftHistory.value;
  }

}
