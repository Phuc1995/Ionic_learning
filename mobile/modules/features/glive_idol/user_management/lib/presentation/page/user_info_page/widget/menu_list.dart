import 'package:badges/badges.dart';
import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/domain/entity/response/profile_response.dart';

class MenuList extends StatelessWidget {
  final ProfileResponse profile;
  final Function(String) onPressed;

  const MenuList({
    Key? key,
    required this.onPressed,
    required this.profile
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            text: 'home_idol_info'.tr,
            onPressed: () {
                  this.onPressed(IdolRoutes.user_management.accountInfoEdit);
            },
          ),
          _buildMenuItem(
            text: 'payment_statistic_app_bar_title'.tr,
            onPressed: () async {
                  this.onPressed(IdolRoutes.payment.paymentStatisticPage);
            },
          ),
          _buildMenuItem(
            text: 'home_setting'.tr,
            badgeContent: profile.needLinkAccount() || profile.passwordUpdatedDate == null  ? '!' : '',
            onPressed: () async {
                  this.onPressed(IdolRoutes.user_management.settingPage);
            },
          ),
          _buildMenuItem(
            text: 'home_feedback'.tr,
            onPressed: () async {
                  this.onPressed(IdolRoutes.user_management.reportPage);
            },
          ),
          _buildMenuItem(
            text: 'home_contact'.tr,
            onPressed: () {},
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
