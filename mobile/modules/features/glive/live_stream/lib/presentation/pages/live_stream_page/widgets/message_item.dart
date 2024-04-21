import 'package:common_module/common_module.dart';
import 'package:common_module/presentation/widget/image/avatar_cached_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_stream/constants/assets.dart';
import 'package:live_stream/presentation/controller/live/live_controller.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/idol_detail_sheet/idol_detail_sheet.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/manage_user/show_user_manage.dart';
import 'package:user_management/controllers/controllers.dart';

class MessageItem extends StatelessWidget {
  final LiveMessageDto message;
  final String storageUrl;

  const MessageItem({
    Key? key,
    required this.message,
    required this.storageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var liveMessage = message.obs;
    final _liveController = Get.put(LiveController());
    return !liveMessage.value.isSystem
        ? Container(
            margin: EdgeInsets.only(bottom: 2.5.h, left: 20.w),
            padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 8.h),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.black26.withOpacity(0.2),
                borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(5)))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                liveMessage.value.type == LiveMessageTypes.level_up ? Container() : Container(
                  width: 35.w,
                  height: 35.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.pink1,
                  ),
                  child: Center(
                    child: InkWell(
                        onTap: () {
                          if(liveMessage.value.id == _liveController.currentRoom.value.id){
                            _liveController.isShownGiftBox.value = true;
                            showModalBottomSheet<void>(
                              context: context,
                              backgroundColor: Colors.black12.withOpacity(0.0),
                              builder: (BuildContext context) {
                                return IdolDetailSheet(roomId: _liveController.currentRoom.value.id,);
                              },
                            ).whenComplete(() {
                              _liveController.isShownGiftBox.value = false;
                            });
                          } else {
                            FollowController _followController = Get.put(FollowController());
                            _followController.getCountFollowingViewer(liveMessage.value.id);
                            showModalBottomSheet<void>(
                              context: context,
                              backgroundColor: Colors.black12.withOpacity(0.0),
                              builder: (BuildContext context) {
                                return ShowUserManage(
                                  liveMessage: liveMessage,
                                  storageUrl: storageUrl,
                                );
                              },
                            );
                          }
                        },
                        child: AvatarCachedNetwork(storageUrl: storageUrl, defaultAvatar: Assets.defaultRoomAvatar, fileUrl:message.imageUrl,)),
                  ),
                ),
                SizedBox(
                  width: liveMessage.value.type == LiveMessageTypes.level_up ? 5.w : 10.w,
                ),
                _messageContent(liveMessage, _liveController),
              ],
            ),
          )
        : Padding(
            padding: EdgeInsets.only(left: 30.w, top: 10.h),
            child: _messageContent(liveMessage, _liveController),
          );
  }

  Flexible _messageContent(Rx<LiveMessageDto> message, LiveController controller) {
    String msg = ' ';
    bool isJoin = false;
    if (message.value.type == LiveMessageTypes.join) {
      isJoin = true;
      msg += 'live_message_join'.tr;
    } else if (message.value.type == LiveMessageTypes.leave) {
      msg += 'live_message_leave'.tr;
    } else if (message.value.type == LiveMessageTypes.ban) {
      isJoin = true;
      msg += 'live_message_ban'.tr;
    } else if (message.value.type == LiveMessageTypes.gift) {
      msg += 'live_message_send'.tr + message.value.content;
    } else if (message.value.type == LiveMessageTypes.follow) {
      msg += 'follow_message_content'.tr + message.value.content;
    }else if (message.value.type == LiveMessageTypes.level_up) {
      msg += 'Level ' + message.value.level!;
    }else {
      msg += message.value.content;
    }
    return Flexible(
      child: Obx(() => Container(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                message.value.isManager
                    ? Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r), color: AppColors.whiteSmoke6),
                        child: Padding(
                          padding: EdgeInsets.all(4.r),
                          child: Text(
                            "live_manage_censor".tr,
                            style: TextUtils.textStyle(FontWeight.w500, 10.sp, color: Colors.white),
                          ),
                        ),
                      )
                    : Container(),
                message.value.type == LiveMessageTypes.level_up ? Container(
                  child: RichText(
                    text: TextSpan(
                      text: '',
                      children: [
                        WidgetSpan(
                            child: Image.asset(Assets.congratulation)
                        ),
                        TextSpan(
                            text:  'level_up_msg_congratulations'.tr,
                            style: TextUtils.textStyle(FontWeight.w400, 15.sp, color: AppColors.yellow4)),
                        TextSpan(
                            text:  message.value.gId,
                            style: TextUtils.textStyle(FontWeight.w400, 15.sp, color: AppColors.yellow, fontStyle: FontStyle.italic)),
                        TextSpan(
                            text:  " lên ",
                            style: TextUtils.textStyle(FontWeight.w400, 15.sp, color: AppColors.yellow4)),
                        TextSpan(
                            text:  msg + " ",
                            style: TextUtils.textStyle(FontWeight.w400, 15.sp, color: AppColors.turquoise)),
                        WidgetSpan(
                            child: Image.asset(Assets.party_popper)
                        ),
                        WidgetSpan(
                            child: Image.asset(Assets.party_popper)
                        )
                      ],
                    ),

                  ),
                ) :Container(

                  child: RichText(
                    text: TextSpan(
                      text: '',
                      children: [
                        if(message.value.id == controller.currentRoom.value.id)
                          WidgetSpan(child: Image.asset(Assets.idol_message, width: 26.w, height: 20.h,)),
                        TextSpan(
                            text: message.value.gId + '',
                            style: TextStyle(
                              color: AppColors.yellow,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                            )),
                        WidgetSpan(
                            child: Container(
                              margin: EdgeInsets.only(left: 3.w, right: 10.w, bottom: 3.h),
                              width: 40.w,
                              constraints: BoxConstraints(maxHeight: 17.h),
                              padding: EdgeInsets.symmetric(horizontal: 1.w),
                              decoration: BoxDecoration(
                                color: AppColors.turquoise,
                                borderRadius: BorderRadius.circular(40.r),
                              ),
                              child: Center(
                                child: Text(
                                  "Lv" + message.value.level!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10.sp,
                                    ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                        ),
                        TextSpan(
                            text:  msg,
                            style: _messageTextStyle(message.value.type!, message.value.me, isJoin)),
                      ],
                    ),

                  ),
                ),
              ],
            ),
      )),
    );
  }

  TextStyle _messageTextStyle(String messageType, bool isMe, bool isJoin){
    TextStyle textStyle= TextStyle(
      color: (isMe || isJoin) ? AppColors.pink1 : Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 16.sp,
    );
    switch(messageType){
      case LiveMessageTypes.follow:
        textStyle = TextUtils.textStyle(FontWeight.w500, 17.sp, color: Colors.white);
        break;
    }
    return textStyle;
  }
}
