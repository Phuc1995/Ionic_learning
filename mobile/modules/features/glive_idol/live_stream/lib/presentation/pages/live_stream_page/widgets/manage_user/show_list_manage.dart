import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_stream/constants/constants.dart';
import 'package:live_stream/dto/add_viewer_permission_dto.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/manage_user/all_list_manage.dart';
import 'package:live_stream/services/services.dart';

class ShowListManage extends StatelessWidget {
  final Rx<LiveMessageDto> liveMessage;
  final String storageUrl;

  const ShowListManage({Key? key, required this.liveMessage, required this.storageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        height: 300.h,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 220.h,
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  _buildTextButton("live_manage_report_button".tr, (){},),
                  Divider(thickness: 1.h, color: AppColors.whiteSmoke11,),
                  Obx(() => _buildTextButton(liveMessage.value.isLocked ? "live_manage_limit_remove_button".tr : "live_manage_limit_button".tr, (){
                    if(liveMessage.value.isLocked){
                      _handleRemoveLimitUser(context, liveMessage.value.name);
                    } else {
                      _handleAddLimitUser(context, liveMessage.value.name);
                    }
                  }),),
                  Divider(thickness: 1.h, color: AppColors.whiteSmoke11,),
                  _buildTextButton("live_manage_list_button".tr, (){
                    showModalBottomSheet<void>(
                      enableDrag: true,
                      context: context,
                      backgroundColor: Colors.black12.withOpacity(0.0),
                      builder: (BuildContext context) {
                        return AllListManage(liveMessage: liveMessage, storageUrl: storageUrl,);
                      },
                    );
                  }),
                  Divider(thickness: 1.h, color: AppColors.whiteSmoke11,),
                Obx(() => _buildTextButton(liveMessage.value.isManager ?  "live_manage_censor_remove_button".tr : "live_manage_censor_button".tr, () async{
                  if(liveMessage.value.isManager){
                    _handleRemoveCensor(context, liveMessage.value.name);
                  } else {
                    _handleAddCensor(context, liveMessage.value.name);
                  }
                }),)
                ],
              ),
            ),
            Divider(thickness: 3.h, color: AppColors.whiteSmoke11,),
            _buildTextButton("live_manage_cancel_button".tr, (){
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );

  }

  Widget _buildTextButton(String text, Function() onTap ){
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(top: text == "live_manage_cancel_button".tr ? 15.h : 10.h, bottom: text == "live_manage_cancel_button".tr ? 15.h :10.h),
        child: Container(
          width: double.infinity,
          child: Center(
            child: Text(
                text,
                style: TextUtils.textStyle(FontWeight.w400, 16.sp, color: AppColors.grayCustom2),),
          ),
        ),
      ),
    );
  }

  void _handleAddCensor(BuildContext context, String fullName) async {
    ShowDialog().showMessage(context, fullName + "live_manage_censor_title".tr, "live_manage_confirm_button".tr, () async {
      final liveStreamService = Modular.get<LiveStreamService>();
      final response = await liveStreamService.addViewerPermission(AddViewerPermissionDto(title: ViewerPermissionType.LIVE_ROOM_MANAGER, userUuid: liveMessage.value.id, isRemove: false));
      response.fold((l) => null, (r) {
        liveMessage.value.isManager = true;
        liveMessage.refresh();
        ShowShortMessage().showTop(context: context, message: fullName + "live_manage_censor_show_message".tr, messageColor: Colors.white, backgroundColor: AppColors.pinkLiveButtonCustom);
        Navigator.pop(context);
      });
    }, textButton2: "live_manage_cancel_button".tr, onButton2: (){
      Navigator.pop(context);
    });

  }

  void _handleRemoveCensor(BuildContext context, String fullName) async {
    ShowDialog().showMessage(context, fullName + "live_manage_censor_remove_title".tr, "live_manage_confirm_button".tr, () async {
      final liveStreamService = Modular.get<LiveStreamService>();
      final response = await liveStreamService.addViewerPermission(AddViewerPermissionDto(title: ViewerPermissionType.LIVE_ROOM_MANAGER, userUuid: liveMessage.value.id, isRemove: true));
      response.fold((l) => null, (r) {
        liveMessage.value.isManager = false;
        liveMessage.refresh();
        ShowShortMessage().showTop(context: context, message: fullName + "live_manage_censor_remove_show_message".tr, messageColor: Colors.white, backgroundColor: AppColors.pinkLiveButtonCustom);
        Navigator.pop(context);
      });
    }, textButton2: "live_manage_cancel_button".tr, onButton2: (){
      Navigator.pop(context);
    });
  }

  void _handleAddLimitUser(BuildContext context, String fullName) async {
    ShowDialog().showMessage(context, fullName + "live_manage_limit_title".tr, "live_manage_confirm_button".tr, () async {
      final liveStreamService = Modular.get<LiveStreamService>();
      final response = await liveStreamService.addViewerPermission(AddViewerPermissionDto(title: ViewerPermissionType.LIVE_ROOM_LOCKED_CHAT, userUuid: liveMessage.value.id, isRemove: false));
      response.fold((l) => null, (r) {
        liveMessage.value.isLocked = true;
        liveMessage.refresh();
        ShowShortMessage().showTop(context: context, message: fullName + "live_manage_limit_message".tr, messageColor: Colors.white, backgroundColor: AppColors.pinkLiveButtonCustom);
        Navigator.pop(context);
      });
    }, textButton2: "live_manage_cancel_button".tr, onButton2: (){
      Navigator.pop(context);
    });

  }

  void _handleRemoveLimitUser(BuildContext context, String fullName) async {
    ShowDialog().showMessage(context, fullName + "live_manage_limit_remove_title".tr, "live_manage_confirm_button".tr, () async {
      final liveStreamService = Modular.get<LiveStreamService>();
      final response = await liveStreamService.addViewerPermission(AddViewerPermissionDto(title: ViewerPermissionType.LIVE_ROOM_LOCKED_CHAT, userUuid: liveMessage.value.id, isRemove: true));
      response.fold((l) => null, (r) {
        liveMessage.value.isLocked = false;
        liveMessage.refresh();
        ShowShortMessage().showTop(context: context, message: fullName + "live_manage_limit_remove_message".tr, messageColor: Colors.white, backgroundColor: AppColors.pinkLiveButtonCustom);
        Navigator.pop(context);
      });
    }, textButton2: "live_manage_cancel_button".tr, onButton2: (){
      Navigator.pop(context);
    });
  }

}


