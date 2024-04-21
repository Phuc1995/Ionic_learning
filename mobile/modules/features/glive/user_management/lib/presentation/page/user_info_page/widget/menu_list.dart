import 'package:badges/badges.dart';
import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment/service/top_up_service.dart';
import 'package:user_management/controllers/user_store_controller.dart';
import 'package:user_management/dto/dto.dart';

class MenuList extends StatelessWidget {
  final ProfileResponseDto profile;
  final Function(String) onPressed;

  const MenuList({Key? key, required this.onPressed, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserStoreController _userStoreController = Get.put(UserStoreController());
    var isWaiting = false;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 4.w,
            color: AppColors.whiteSmoke2,
          ),
        ),
      ),
      child: Column(
        children: <Widget>[
          _buildMenuItem(
            text: 'home_recharge'.tr,
            onPressed: () => _userStoreController.onPressedHomeRecharge(isWaiting),
          ),
          _buildMenuItem(
            text: 'home_personal_information'.tr,
            onPressed: () {
              this.onPressed(ViewerRoutes.account_info_edit);
            },
          ),
          _buildMenuItem(
            text: 'home_view_history'.tr,
            onPressed: () {
              Modular.to.pushNamed(ViewerRoutes.payment_recharge_history);
            },
          ),
          // _buildMenuItem(
          //   text: 'payment_statistic_app_bar_title'.tr,
          //   onPressed: () {
          //     // this.onPressed(ViewerRoutes.transaction_history);
          //     this.onPressed(ViewerRoutes.statistic);
          //   },
          // ),
          _buildMenuItem(
            text: 'home_user_manual'.tr,
            onPressed: () {},
          ),
          _buildMenuItem(
            text: 'home_feedback'.tr,
            onPressed: () {
              // Livechat.beginChat(dotenv.env['LIVE_CHAT_LICENSE_NO']!, dotenv.env['LIVE_CHAT_GROUP']!, _sharedPrefsHelper.getUserNameSupport!, _sharedPrefsHelper.getUserMailSupport!);
              this.onPressed(ViewerRoutes.support);
            },
          ),
          // _buildMenuItem(
          //   text: 'home_contact'.tr,
          //   onPressed: () {
          //     this.onPressed(ViewerRoutes.support);
          //   },
          // ),
          _buildMenuItem(
            text: 'home_setting'.tr,
            badgeContent: profile.needLinkAccount() || profile.passwordUpdatedDate == null  ? '!' : '',
            onPressed: () {
              this.onPressed(ViewerRoutes.setting_page);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String text,
    required VoidCallback onPressed,
    String badgeContent = '',
  }) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          badgeContent.isNotEmpty
              ? SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Badge(
                  elevation: 0,
                  shape: BadgeShape.circle,
                  badgeColor: Colors.red,
                  padding: EdgeInsets.all(5),
                  badgeContent: Text(
                    badgeContent,
                    style:
                    TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.chevron_right,
                    color: AppColors.whiteSmoke,
                  ),
                ),
              ],
            ),
          )
          : Icon(
            Icons.chevron_right,
            color: AppColors.whiteSmoke,
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
