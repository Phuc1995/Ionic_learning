import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/presentation/controller/user/user_store_controller.dart';

class SubButton extends StatelessWidget {
  const SubButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserStoreController userStoreController = Get.put(UserStoreController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: TextButton(
            child: Text(
              'login_btn_register'.tr,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(color: Colors.white, fontSize: 16.sp, decoration: TextDecoration.underline),
            ),
            onPressed: () async {
                  userStoreController.setupRegister();
                  Modular.to.pushNamed(IdolRoutes.user_management.registerStep1);
            },
          ),
        ),
        Container(
          child: TextButton(
            child: Text(
              'login_btn_forgot_password'.tr,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(color: Colors.white, fontSize: 16.sp, decoration: TextDecoration.underline),
            ),
            onPressed: () async {
                  Modular.to.pushNamed(IdolRoutes.user_management.forgotPassword);
            },
          ),
        )
      ],
    );
  }
}
