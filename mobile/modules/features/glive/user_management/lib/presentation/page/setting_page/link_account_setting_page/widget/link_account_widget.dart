import 'package:common_module/common_module.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:user_management/controllers/link_account_store_controller.dart';
import 'package:user_management/controllers/user_store_controller.dart';
import 'package:user_management/dto/dto.dart';
import 'package:user_management/presentation/page/setting_page/link_account_setting_page/widget/link_account_item.dart';

class LinkAccountWidget extends StatelessWidget {
  final UserStoreController userStoreController;
  final ProfileResponseDto profile;
  final Function(Object? value)? onBack;

  const LinkAccountWidget(
      {Key? key,
      required this.userStoreController,
      required this.profile,
      this.onBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    late LinkAccountStoreController _linkAccountStoreController = Get.put(LinkAccountStoreController());
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      LinkAccountItem(
          icon: Container(
            padding: EdgeInsets.zero,
            child: Icon(
              Icons.smartphone,
              size: 18.sp,
              color: Colors.white,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              color: Colors.teal
            ),
          ),
          label: 'link_account_phone'.tr,
          linkedLabel: _linkAccountStoreController.hideMobile(this.profile.mobile),
          isLinked: this.profile.mobile.isNotEmpty,
          onPressed: () async {
            if (this.profile.mobile.isEmpty) {
              Modular.to.pushNamed(
                  IdolRoutes.user_management.settingLinkAccountPhoneEmailPage,
                  arguments: {
                    'isPhone': true,
                  }).then((value) {
                if (onBack != null) onBack!(value);
              });
            }
          }),
      LinkAccountItem(
          icon: Container(
            padding: EdgeInsets.zero,
            child: Icon(
              Icons.mail,
              size: 18.sp,
              color: Colors.white,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              color: Colors.blueAccent,
            ),
          ),
          label: 'Email',
          linkedLabel: _linkAccountStoreController.hideEmail(this.profile.email),
          isLinked: this.profile.email.isNotEmpty,
          onPressed: () async {
            if (this.profile.email.isEmpty) {
              Modular.to.pushNamed(
                  IdolRoutes.user_management.settingLinkAccountPhoneEmailPage,
                  arguments: {
                    'isPhone': false,
                  }).then((value) {
                if (onBack != null) onBack!(value);
              });
            }
          }),
    ]);
  }

}
