import 'dart:async';

import 'package:common_module/common_module.dart';
import 'package:common_module/presentation/widget/image/avatar_cached_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'custom_dialog_message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowDialog{

  showMessage(BuildContext context, String title, String textButton, Function onClose, {String? textButton2='', Function? onButton2}){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new CustomDialogMessage(
            buttonText: textButton,
            title: title,
            onPressed: onClose,
            buttonText2: textButton2!,
            onPressed2: onButton2,
          );
        });
  }

  Future<void> showEnableNotifyDialog(BuildContext context, {String? storageUrl, String? fileUrl, Widget? icon, String? defaultAvatar}) async {
    final dialogContextCompleter = Completer<BuildContext>();
    Future.delayed(Duration(seconds: 2),() async{
      final dialogContext = await dialogContextCompleter.future;
      Navigator.pop(dialogContext);
    });
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        if(!dialogContextCompleter.isCompleted) {
          dialogContextCompleter.complete(dialogContext);
        }
        return AlertDialog(
          content: Container(
            height: 180.h,
            child: Column(
              children: [
                Stack(
                  children: [
                    Center(
                      child: Container(
                          width: 100,
                          height: 100,
                          child: AvatarCachedNetwork(storageUrl:  storageUrl??"", fileUrl: fileUrl??"", defaultAvatar: defaultAvatar??"")),
                    ),
                    icon != null ? icon : Container(),
                  ],
                ),
                SizedBox(height: 20.h,),
                Container(
                    width: 220.w,
                    child: Text('follow_idol_enable_live'.tr, style: TextUtils.textStyle(FontWeight.w600, 13.sp), textAlign: TextAlign.center,))
              ],
            ),
          ),
        );
      },
    );
  }

}