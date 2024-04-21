import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_management/constants/assets.dart';
import 'package:user_management/domain/entity/image_path/image_path.dart';
import 'package:user_management/presentation/controller/image/image_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/presentation/widgets/icon_button_widget.dart';
import 'package:get/get.dart';
import 'package:common_module/common_module.dart';

class AvatarWidget extends StatelessWidget {
  final ImageController imageController;
  final String fileUrl;
  final SharedPreferenceHelper sharedPrefsHelper;
  final Function(String)? onChange;

  const AvatarWidget({
    Key? key,
    required this.sharedPrefsHelper,
    required this.imageController,
    this.fileUrl = '',
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String storageUrl =
        this.sharedPrefsHelper.storageServer + '/' + this.sharedPrefsHelper.bucketName + '/';
    ImageProvider img = AssetImage(Assets.defaultAvatar);
    if (this.fileUrl != '') {
      try {
        String url = this.fileUrl.startsWith('http://') || this.fileUrl.startsWith('https://') ? this.fileUrl : (storageUrl + this.fileUrl);
        img = NetworkImage(url);
      } catch (err) {
        img = AssetImage(Assets.defaultAvatar);
      }
    }
    return Container(
      margin: EdgeInsets.only(bottom: 30.h),
      height: 180.h,
      width: 180.w,
      child: SizedBox(
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            Center(
              child: Container(
                  height: 125.h,
                  width: 125.w,
                  child: CircleAvatar(backgroundImage: img)),
            ),
            Container(
              alignment: Alignment.center,
              child:
              Obx(() => Container(
                child: Image.network(
                    imageController.armorial.value
                ),
              ),)
            ),
            Positioned(
              bottom: 40.h,
              right: 25.w,
              height: 25.h,
              width: 28.w,
              child: IconButtonWidget(
                buttonColor: AppColors.pinkGradientButton,
                onPressed: () {
                  _showChoiceDialog(context);
                },
                icon: Icons.photo_camera,
                iconSize: 14.sp,
                width: 50.w,
                height: 50.h,
              ),
            ),
            Obx(() => Visibility(
                  visible: imageController.loading.value,
                  child: CustomProgressIndicatorWidget(),
                )),
          ],
        ),
      ),
    );
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('avatar_choose'.tr),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text('avatar_gallery'.tr),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      _openPicker(ctx, ImageSource.gallery);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text('avatar_camera'.tr),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      _openPicker(ctx, ImageSource.camera);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  _openPicker(BuildContext context, ImageSource source) async {
    ImagePicker _picker = new ImagePicker();
    var image = await _picker.getImage(
      source: source,
      imageQuality: 75,
    );
    _cropImage(context, image!.path.toString());
    Navigator.of(context).pop();
  }

  _cropImage(BuildContext context, String filePath) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: filePath,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      imageController.loading.value = true;
      final res = await imageController.upload(
          context, new ImagePath(path: croppedFile.path.toString(), type: 'avatar'));
      res.fold((left) {
        imageController.loading.value = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(left.message.tr)));
      }, (right) {
        imageController.loading.value = false;
        if (this.onChange != null) {
          this.onChange!(right.path);
        }
      });
    }
  }
}
