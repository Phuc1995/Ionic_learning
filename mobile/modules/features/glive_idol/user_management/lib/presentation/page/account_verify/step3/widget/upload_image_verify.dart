import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_management/constants/custom_icons.dart';
import 'package:user_management/constants/identityType.dart';
import 'package:user_management/presentation/controller/user/account_verify_store_controller.dart';
import 'package:user_management/presentation/widgets/upload_confirm_info_widget.dart';

class UploadImageVerifyWidget extends StatefulWidget {
  final AccountVerifyStoreController accountVerifyStoreController;
  final bool isFront;

  const UploadImageVerifyWidget({
    Key? key,
    required this.accountVerifyStoreController,
    required this.isFront,
  }) : super(key: key);

  @override
  _UploadImageVerifyWidgetState createState() => _UploadImageVerifyWidgetState();
}

class _UploadImageVerifyWidgetState extends State<UploadImageVerifyWidget> {
  var isUploaded = false.obs;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => UploadConfirmInfoWidget(
        onFileChanged: (file) {
          if (file != '') {
            if (widget.isFront) {
              widget.accountVerifyStoreController.photoFrontController.value = file;
            } else {
              widget.accountVerifyStoreController.photoBackController.value = file;
            }
            isUploaded.value = true;
          }
        },
        icon: widget.accountVerifyStoreController.typeController.value == IdentityType.identityCard
            ? CustomIcons.cccd_front
            : widget.accountVerifyStoreController.typeController.value == IdentityType.passport
                ? CustomIcons.passport_outline
                : CustomIcons.driver_lic,
        title: widget.isFront
            ? 'account_verify_upload_frontend'.tr
            : 'account_verify_upload_backend'.tr,
        isUploaded: isUploaded.value ? 1 : 0,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
