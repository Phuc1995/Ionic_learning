import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_management/constants/assets.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/dto/image_path_dto.dart';
import 'package:user_management/controllers/image_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/controllers/user_store_controller.dart';
import 'package:user_management/presentation/widgets/icon_button_widget.dart';
import 'package:get/get.dart';

class AvatarWidget extends StatefulWidget {
  final String fileUrl;
  final String storageUrl;
  final String armorial;
  final double height;
  final double radius;
  final bool isAvatarProfile;
  final Function(String)? onChange;

  const AvatarWidget({
    Key? key,
    this.fileUrl = '',
    this.storageUrl = '',
    this.onChange,
    this.height = 180,
    this.isAvatarProfile = true,
    this.armorial = '',
    this.radius = 20,
  }) : super(key: key);

  @override
  _AvatarWidgetState createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  UserStoreController _userStoreController = Get.put(UserStoreController());
  ImageController _imageController = Get.put(ImageController());
  @override
  Widget build(BuildContext context) {
    String url = this.widget.fileUrl.startsWith('http://') || this.widget.fileUrl.startsWith('https://') ? this.widget.fileUrl : (widget.storageUrl + this.widget.fileUrl);
    Widget img = this.widget.fileUrl.isNotEmpty ? CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Container(
          height: 120.h,
          width: 125.w,
          child: CircleAvatar(backgroundImage: AssetImage(Assets.defaultAvatar))),
      imageBuilder: (context, imageProvider) => Container(
          height: 120.h,
          width: 125.w,
          child: CircleAvatar(backgroundImage: imageProvider)),
    ) : Container(
        height: 120.h,
        width: 125.w,
        child: CircleAvatar(backgroundImage: AssetImage(Assets.defaultAvatar)));
    return Container(
      margin: EdgeInsets.only(bottom: 30.h),
      height: widget.height.h,
      width: double.infinity,
      child: SizedBox(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.all(widget.radius.r),
                child: FittedBox(
                    fit: BoxFit.cover,
                    child: img),
              ),
            ),
            widget.isAvatarProfile ? Center(
              child: Container(
                  child: Obx(() => _userStoreController.profile.value.level != null ? Container(
                    child: ImageCachedNetwork(
                      defaultAvatar: Assets.defaultRoomAvatar,
                      fileUrl: _userStoreController.profile.value.level!.armorial,
                      storageUrl: widget.storageUrl,
                        boxFit: BoxFit.fitHeight,
                        // widget.imageController.armorial.value
                    ),
                  ): Container())
              ),
            ) : Center(
              child: Container(
                    child: ImageCachedNetwork(
                      defaultAvatar: Assets.defaultRoomAvatar,
                      fileUrl: widget.armorial,
                      storageUrl: widget.storageUrl,
                      boxFit: BoxFit.fitHeight,
                      // widget.imageController.armorial.value
                    ),
                  )
              ),
            widget.isAvatarProfile ? Center(
              child: Container(
                margin: EdgeInsets.only(left: 105.w, top: 70.h),
                height: 35.h,
                width: 35.w,
                child: IconButtonWidget(
                  buttonColor: AppColors.pinkGradientButton,
                  onPressed: () {
                    _showChoiceDialog(context);
                  },
                  icon: Icons.photo_camera,
                  iconSize: 18.sp,
                ),
              ),
            ) : Container(),
            Obx(() => Visibility(
                  visible: _imageController.loading.value,
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
      _imageController.loading.value = true;
      final res = await _imageController.upload(
          context, new ImagePathDto(path: croppedFile.path.toString(), type: 'avatar'));
      res.fold((left) {
        _imageController.loading.value = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(left.message.tr)));
      }, (right) {
        _imageController.loading.value = false;
        if (this.widget.onChange != null) {
          this.widget.onChange!(right.path);
        }
      });
    }
  }
}
