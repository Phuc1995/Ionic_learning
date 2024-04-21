import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:user_management/domain/entity/response/profile_response.dart';
import 'package:user_management/presentation/controller/user/user_store_controller.dart';
import 'package:user_management/presentation/page/setting_page/link_account_setting_page/widget/link_account_item.dart';

class LinkAccountWidget extends StatelessWidget {
  final UserStoreController userStoreController;
  final ProfileResponse profile;
  final Function(Object? value)? onBack;

  const LinkAccountWidget(
      {Key? key,
      required this.userStoreController,
      required this.profile,
      this.onBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          linkedLabel: _hideMobile(this.profile.mobile),
          isLinked: this.profile.mobile.isNotEmpty,
          onPressed: () {
            if (this.profile.mobile.isEmpty) {
              Modular.to.pushNamed(
                  IdolRoutes.user_management.settingLinkAccountPhoneEmailPage,
                  arguments: {
                    'isPhone': true,
                  }).then((value) {
                if (onBack != null) onBack!(value);
              });
            } else {
              // TODO change phone number
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
          linkedLabel: _hideEmail(this.profile.email),
          isLinked: this.profile.email.isNotEmpty,
          onPressed: () {
            if (this.profile.email.isEmpty) {
              Modular.to.pushNamed(
                  IdolRoutes.user_management.settingLinkAccountPhoneEmailPage,
                  arguments: {
                    'isPhone': false,
                  }).then((value) {
                if (onBack != null) onBack!(value);
              });
            } else {
              // TODO change phone number
            }
          }),
    ]);
  }

  String _hideMobile(String mobile) {
    if (mobile.isEmpty) return '';
    if (mobile.length == 8) {
      return mobile.substring(0, 4) + '***' + mobile.substring(mobile.length - 2);
    } else if (mobile.length > 8) {
      return mobile.substring(0, 4) + '***' + mobile.substring(mobile.length - 4);
    } else {
      return mobile;
    }
  }
  String _hideEmail(String email) {
    if (email.isEmpty) return '';
    List<String> strs = email.split('@');
    if (strs.length > 1) {
       String start = strs[0];
       if (strs[0].length > 3) {
         start = strs[0].substring(0, 3);
       }
       int dotIndex = strs[1].indexOf('.');
       String end = strs[1].substring(dotIndex);
       return start + '***@***' + end;
    } else {
      return email;
    }
  }
}
