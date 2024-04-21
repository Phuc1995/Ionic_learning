import 'dart:io';
import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_stream/controllers/camera_live_controller.dart';
import 'package:user_management/constants/assets.dart';
import 'package:user_management/domain/entity/image_path/image_path.dart';
import 'package:user_management/presentation/controller/image/image_controller.dart';
import 'package:user_management/presentation/widgets/icon_button_widget.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThumbnailWidget extends StatefulWidget {
  @override
  _ThumbnailWidgetState createState() => _ThumbnailWidgetState();
  final Function(String)? onChange;
  final SharedPreferenceHelper sharedPrefsHelper;
  final String storageUrl;

  final ImageController imageController;

  const ThumbnailWidget({
    Key? key,
    required this.sharedPrefsHelper,
    required this.imageController,
    required this.storageUrl,
    this.onChange,
  }) : super(key: key);
}

class _ThumbnailWidgetState extends State<ThumbnailWidget> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  String fileUrl = '';
  ImageController imageController = Get.put(ImageController());
  CameraLiveController cameraLiveController = Get.put(CameraLiveController());
  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(bottom: 30),
      height: 80.h,
      width: 80.w,
      child: SizedBox(
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            InkWell(
              onTap: (){
                _openPicker(context, ImageSource.gallery);
              },
              child: Container(
                height: 80.h,
                width: 80.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  image: fileUrl == ''
                      ? (widget.sharedPrefsHelper.thumbnail != null && widget.sharedPrefsHelper.thumbnail != '')
                          ? DecorationImage(
                              image:
                                  NetworkImage(widget.storageUrl + widget.sharedPrefsHelper.thumbnail.toString()),
                              fit: BoxFit.fitWidth)
                          : DecorationImage(
                              image: AssetImage(Assets.defaultRoomAvatar), fit: BoxFit.fitWidth)
                      : DecorationImage(
                          image: NetworkImage(widget.storageUrl + fileUrl), fit: BoxFit.fitWidth),
                ),
              ),
            ),
            Positioned(
              bottom: 1.h,
              right: 0,
              height: 25.h,
              width: 25.w,
              child: IconButtonWidget(
                buttonColor: AppColors.pinkGradientButton,
                onPressed: () {
                  _openPicker(context, ImageSource.gallery);
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

  _openPicker(BuildContext context, ImageSource source) {
    cameraLiveController.isThumbnailCamera.value = true;
    Future<PickedFile?> _imageFile;
    ImagePicker _picker = new ImagePicker();
    _imageFile = _picker.getImage(source: source);
    _imageFile.then((file) async {
      if (file != null) {
        await _cropImage(context, file.path.toString());
        cameraLiveController.isThumbnailCamera.value = false;
      }
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('lỗi')));
    });
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
      widget.imageController.loading.value = true;
      final res = await widget.imageController.uploadThumbnail(
          context, new ImagePath(path: croppedFile.path.toString(), type: 'thumbnail'));
      res.fold((left) {
        widget.imageController.loading.value = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(left.message.tr)));
      }, (right) {
        widget.imageController.loading.value = false;
        widget.sharedPrefsHelper.setThumbnail(right.path);
        setState(() {
          fileUrl = right.path;
        });
        // Get.resetCustom();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
