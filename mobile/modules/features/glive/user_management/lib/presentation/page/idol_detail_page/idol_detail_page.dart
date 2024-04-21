import 'package:flutter/material.dart';
import 'package:common_module/common_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/constants/assets.dart';
import 'package:user_management/controllers/follow_controller.dart';
import 'package:user_management/presentation/page/follow_page/widget/show_unfollow_sheet.dart';
import 'package:user_management/presentation/page/idol_detail_page/widget/idol_detail_image_widget.dart';
import 'package:user_management/presentation/page/idol_detail_page/widget/idol_detail_info_widget.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class IdolDetailPage extends StatefulWidget {
  final String uuidIdol;
  final bool isBanned;
  const IdolDetailPage({Key? key, required this.uuidIdol, required this.isBanned}) : super(key: key);

  @override
  State<IdolDetailPage> createState() => _IdolDetailPageState();
}

class _IdolDetailPageState extends State<IdolDetailPage> {
  FollowController _followController = Get.put(FollowController());
  String storageUrl = Modular.get<SharedPreferenceHelper>().getStorageUrl();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isBanned){
      Fluttertoast.showToast(
          msg: "follow_idol_banned_toast".tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
          backgroundColor: AppColors.grayCustom3,
          textColor: Colors.white,
          fontSize: 14.sp,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Modular.to.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: DeviceUtils.buildWidget(context, _buildBody(context)),
      ),
    );
  }

  Widget _buildBody(BuildContext context){
    return Stack(
      children: [
        Column(
          children: [
            IdolDetailImageWidget(),
            IdolDetailInfoWidget(),
            SizedBox(height: 30.h,),
            Divider(height: 5, color: AppColors.whiteSmoke12,)
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 110.h,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.whiteSmoke12,
                  width: 1
                )
              )
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Row(
                children: [
                  Obx(() => Expanded(child: RoundedButtonGradientWidget(
                    textSize: 16.sp,
                    buttonText: _followController.isFollowing.value ? "follow_idol_button".tr : "follow_content".tr,
                    buttonColor: _followController.isFollowing.value ? AppColors.darkGradientBackground : AppColors.pinkGradientButton,
                    textColor: _followController.isFollowing.value ? AppColors.grayCustom1 : Colors.white,
                    width: double.infinity,
                    height: 40.h,
                    iconAsset: _followController.isFollowing.value ? Assets.lineIcon : null,
                    icons: _followController.isFollowing.value ? null : Icon(Icons.add, color: Colors.white,),
                    onPressed: () {
                      if(_followController.isFollowing.value){
                        ShowUnfollowSheet().showUnfollowSheet(context: context, storageUrl: storageUrl, idolDetail: _followController.idolDetail.value, uuidIdol: widget.uuidIdol, followController: _followController);
                      } else {
                        _followController.followIdol(widget.uuidIdol);
                      }
                    },
                  ))),
                  Obx(() => Visibility(
                      visible: _followController.isFollowing.value,
                      child: InkWell(
                        onTap: (){
                              _followController.receiveBellIdol(
                                context: context,
                                uuidIdol: widget.uuidIdol,
                                isReceiveNotify: !_followController.isReceiveNotify.value,
                                storageUrl: storageUrl,
                                imageUrl: _followController.idolDetail.value.imageUrl!,
                              );
                        },
                        child: Container(
                            width: 76.w,
                            height: 40.h,
                            margin: EdgeInsets.only(left: 10.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(40.r)),
                              border: Border.all(color: AppColors.wildWatermelon3, width: 1.5),
                            ),
                            child: Obx(() => Icon(_followController.isReceiveNotify.value ? Icons.notifications : Icons.notifications_none_sharp , color: AppColors.wildWatermelon3, size: 20.sp,))),
                      )),)
                ],
              )),
            ),
          ),
      ],
    );
  }

}
