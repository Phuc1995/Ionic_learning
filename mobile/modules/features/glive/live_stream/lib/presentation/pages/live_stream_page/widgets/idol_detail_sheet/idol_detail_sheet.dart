import 'package:common_module/common_module.dart';
import 'package:common_module/presentation/widget/image/avatar_cached_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_stream/constants/assets.dart';
import 'package:live_stream/presentation/controller/live/live_controller.dart';
import 'package:user_management/controllers/follow_controller.dart';
import 'package:user_management/dto/idol_detail_dto.dart';
import 'package:user_management/presentation/page/user_info_page/widget/count_item.dart';
import 'package:user_management/presentation/widgets/avatar_widget.dart';

class IdolDetailSheet extends StatefulWidget {
  final String roomId;
  const IdolDetailSheet({Key? key, required this.roomId}) : super(key: key);

  @override
  State<IdolDetailSheet> createState() => _IdolDetailSheetState();
}

class _IdolDetailSheetState extends State<IdolDetailSheet> {
  String storageUrl = Modular.get<SharedPreferenceHelper>().storageServer + '/' + Modular.get<SharedPreferenceHelper>().bucketName + '/';
  FollowController _followController = Get.put(FollowController());
  LiveController _liveController = Get.put(LiveController());
  @override
  void initState() {
    _followController.getIdolDetail(widget.roomId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360.h,
      width: 600.w,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 300.h,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 60.h,),
                  Obx(() => _buildSkillsItem(_followController.idolDetail.value)),
                  SizedBox(height: 20.h,),
                  Obx(() => _buildNickName(context, _followController.idolDetail.value)),
                  SizedBox(height: 15.h,),
                  Obx(()=> _buildLevelItem(_followController.idolDetail.value)),
                  SizedBox(height: 20.h,),
                  Divider(thickness: 1.h, color: AppColors.whiteSmoke11,),
                  SizedBox(height: 10.h,),
                  Obx(() => _buildFollowButton(_followController.idolDetail.value, _followController)),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: AvatarWidget(
              armorial: _liveController.armorial.value,
              isAvatarProfile: false,
              height: 120,
              storageUrl: storageUrl,
              fileUrl: _followController.idolDetail.value.imageUrl!,
              onChange: (String val) {
              },
          ),)
        ],
      ),
    );
  }

  Widget _buildSkillsItem(IdolDetailDto idol){
    return Container(
      height: 25.h,
      child: IntrinsicHeight(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Container(
                  color: AppColors.mahogany2,
                  child: Icon(
                    idol.gender == 0 ? Icons.female : Icons.male,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              ClipOval(
                child: Container(
                  width: 22.w,
                  child: Center(
                    child: AvatarCachedNetwork(defaultAvatar: Assets.defaultRoomAvatar, fileUrl: idol.level!.medal, storageUrl: storageUrl,)
                  ),
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              for(var i in idol.skills!) Container(
                margin: EdgeInsets.only(right: 10.w),
                height: 22.h,
                decoration: BoxDecoration(
                    color: AppColors.purple,
                    borderRadius: BorderRadius.all(Radius.circular(20.r))
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 13.w,
                    ),
                    Container(
                        width: 22.w,
                        child: Container(
                            margin: EdgeInsets.symmetric(vertical: 2.h),
                            child: ImageCachedNetwork(
                                defaultAvatar: Assets.defaultRoomAvatar,
                                fileUrl: i.imageUrl,
                                storageUrl: storageUrl,
                                boxFit: BoxFit.fill,
                              ))),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(i.name, style: TextUtils.textStyle(FontWeight.w500, 13.sp, color: Colors.white),),
                    SizedBox(
                      width: 13.w,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelItem(IdolDetailDto idol){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CountItem(count: idol.level!.name, text: 'Level', onTap: () {}),
        CountItem(count: idol.follows!.length.toString(), text: 'follow_idol_fan'.tr, onTap: () {}),
      ],
    );
  }

  Widget _buildNickName(BuildContext context, IdolDetailDto idol) {
    SizeConfig.init(context: context);
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Container(
        width: SizeConfig.blockSizeHorizontal! * 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "${'follow_idol_nickname'.tr}",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
              style: TextStyle(
                color: AppColors.suvaGrey,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            Container(
              height: 20.h,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Text(
                  "${idol.gId}",
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
            ),
            InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: idol.gId)).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'follow_idol_copy'.tr,
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
            Container(
              width: 20.w,
              height: 20.h,
              margin: EdgeInsets.only(left: 5.w),
              child: Image.asset(Assets.verify),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowButton(IdolDetailDto idol, FollowController _followController){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w, ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
           children: [
            Obx(() => Expanded(
              child: RoundedButtonGradientWidget(
                textSize: 16.sp,
                buttonText: _followController.isFollowing.value ? "follow_idol_button".tr : "follow_content".tr,
                buttonColor: _followController.isFollowing.value ? AppColors.darkGradientBackground : AppColors.pinkGradientButton,
                textColor: _followController.isFollowing.value ? AppColors.grayCustom1 : Colors.white,
                height: 40.h,
                iconAsset: _followController.isFollowing.value ? Assets.lineIcon : null,
                icons: _followController.isFollowing.value ? null : Icon(Icons.add, color: Colors.white,),
                onPressed: () {
                  if(_followController.isFollowing.value){
                    _showUnfollowSheet();
                  } else {
                    _followController.followIdol(widget.roomId);
                  }
                },
              ),
            ),),
            Obx(() => Visibility(
              visible: _followController.isFollowing.value,
              child: InkWell(
                  onTap: (){
                    _followController.receiveBellIdol(context: context, uuidIdol: widget.roomId, isReceiveNotify: !_followController.isReceiveNotify.value, storageUrl: storageUrl, imageUrl: _followController.idolDetail.value.imageUrl!);
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
        ),
      ),
    );
  }

  void _showUnfollowSheet(){
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.black12.withOpacity(0.0),
      builder: (BuildContext context) {
        return Container(
          height: 320.h,
          width: 100.w,
          color: Colors.black.withOpacity(0.2),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.r))
            ),
            margin: EdgeInsets.only(left: 50.w, right: 50.w, bottom: 50.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10.h,),
                Container(
                    width: 90.w,
                    height: 90.h,
                    child: AvatarCachedNetwork(storageUrl: storageUrl, defaultAvatar: Assets.defaultAvatar, fileUrl: _followController.idolDetail.value.imageUrl!,)
                ),
                SizedBox(height: 15.h,),
                Text("follow_idol_unfollow_text".tr, style: TextUtils.textStyle(FontWeight.w400, 13.sp, color: AppColors.grayCustom),),
                SizedBox(height: 5.h,),
                Container(
                    height: 20.h                   ,
                    child: FittedBox(
                        fit: BoxFit.fill,
                        child: Text(_followController.idolDetail.value.gId??"", style: TextUtils.textStyle(FontWeight.w500, 14.sp, color: AppColors.wildWatermelon3),))),
                SizedBox(height: 10.h,),
                RoundedButtonWidget(
                  height: 40.h,
                  width: 240.w,
                  buttonText: "follow_idol_unfollow_button".tr,
                  buttonColor: Colors.white,
                  onPressed: (){
                    _followController.unfollowIdol(widget.roomId);
                    Modular.to.pop();
                  },
                  border: Border.all(color: AppColors.wildWatermelon3, width: 1.w),
                  radius: 30,
                  textColor: AppColors.wildWatermelon3,
                ),
                SizedBox(height: 10.h,),
                RoundedButtonWidget(
                  height: 40.h,
                  width: 240.w,
                  buttonText: "follow_idol_keep_follow_button".tr,
                  buttonColor: Colors.white,
                  onPressed: (){
                    Modular.to.pop();
                  },
                  border: Border.all(color: AppColors.whiteSmoke4, width: 1.w),
                  radius: 30,
                  textColor: AppColors.whiteSmoke4,
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}
