import 'dart:convert';

import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_stream/constants/assets.dart';
import 'manage_user/show_user_manage.dart';

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
    return InkWell(
      onTap: (){
        showModalBottomSheet<void>(
          context: context,
          backgroundColor: Colors.black12.withOpacity(0.0),
          builder: (BuildContext context) {
            return ShowUserManage(liveMessage: liveMessage, storageUrl: storageUrl,);
          },
        );
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 2.5.h, left: 20.w),
          padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 8.h),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(5)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AvatarCachedNetwork(storageUrl: storageUrl, defaultAvatar: Assets.defaultRoomAvatar, fileUrl:message.imageUrl,),
              SizedBox(
                width: 10.w,
              ),
              _messageContent(liveMessage),
            ],
          )),
    );
  }

  Flexible _messageContent(Rx<LiveMessageDto> message) {
    String msg = ' ';
    bool isJoin = false;
    if (message.value.type == LiveMessageTypes.join) {
      isJoin = true;
      msg += 'live_message_join'.tr;
    } else if (message.value.type == LiveMessageTypes.leave) {
      msg += 'live_message_leave'.tr;
    } else if (message.value.type == LiveMessageTypes.gift) {
      msg += 'live_message_send'.tr + message.value.content;
    } else if (message.value.type == LiveMessageTypes.follow) {
      msg += 'follow_message_content'.tr + message.value.content;
    }else {
      msg += message.value.content;
    }
    return Flexible(
      child: Obx(() => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          message.value.isManager?
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                color: AppColors.whiteSmoke6
            ),
            child: Padding(
              padding: EdgeInsets.all(4.r),
              child: Text("live_manage_censor".tr,
                style: TextUtils.textStyle(FontWeight.w500, 10.sp, color: Colors.white),),
            ),) : Container(),
          RichText(
            text: TextSpan(
              text: message.value.gId + '',
              style: TextStyle(
                color: AppColors.yellow,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: msg,
                    style: _messageTextStyle(message.value.type!, message.value.me, isJoin)),
              ],
            ),
          ),
        ],
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
