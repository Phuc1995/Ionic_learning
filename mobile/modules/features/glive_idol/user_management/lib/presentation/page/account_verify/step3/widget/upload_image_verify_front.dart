import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:user_management/presentation/controller/image/image_controller.dart';
import 'package:user_management/presentation/controller/user/account_verify_store_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadConfirmFrontWidget extends StatelessWidget {
  final title;
  final IconData? icon;
  final AccountVerifyStoreController accountVerifyStoreController;
  final String? image;

  UploadConfirmFrontWidget(
      {Key? key,
      required this.accountVerifyStoreController,
      required this.title,
      this.icon,
      this.image})
      : super(key: key);

  final _store = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        new Card(
          color: const Color(0xffF7F7F7),
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: new InkWell(
            onTap: () {
              _showChoiceDialog(context);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Container(
                  width: double.infinity,
                  height: 120.h,
                  child: Column(
                    children: [
                      SizedBox(height: 40.h),
                      if (image == '') ...[Icon(icon)],
                      Container(
                        child: Text(
                          image != '' ? '' : title,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18.sp,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  decoration: new BoxDecoration(
                    color: const Color(0xffF7F7F7),
                    image: image != ''
                        ? new DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: Image.file(
                              File(image.toString()),
                            ).image,
                          )
                        : null,
                  ),
                ),
                if (image != '') ...[
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 5.h, 0, 5.h),
                    child: Text('account_verify_change_image'.tr),
                  ),
                ]
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('avatar_choose'.tr),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text('avatar_gallery'.tr),
                    onTap: () {
                      _openPicker(ImageSource.gallery, context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text('avatar_camera'.tr),
                    onTap: () {
                      _openPicker(ImageSource.camera, context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  _openPicker(ImageSource source, BuildContext context) async {
    ImagePicker _picker = new ImagePicker();
    var image = await _picker.getImage(
      source: source,
      imageQuality: 50,
    );
    _buildState(image, context);
    Navigator.of(context).pop();
  }

  _buildState(file, context) async {
    if (file.path.toString() != '') {
      if (await _store.checkFileUpload(file.path.toString())) {
        accountVerifyStoreController.photoFrontController.value = file.path.toString();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('avatar_error'.tr)));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('avatar_error_upload'.tr)));
    }
  }
}
