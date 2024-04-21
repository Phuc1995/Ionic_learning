import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_management/constants/assets.dart';
import 'package:get/get.dart';
import 'package:user_management/presentation/controller/image/image_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadConfirmInfoWidget extends StatefulWidget {
  final ValueChanged<String> onFileChanged;
  final title;
  final IconData? icon;
  final isUploaded;
  final isStep4;
  final Image? image;

  UploadConfirmInfoWidget({
    Key? key,
    required this.onFileChanged,
    required this.title,
    this.icon,
    this.image,
    this.isUploaded = 0,
    this.isStep4 = false,
  }) : super(key: key);

  @override
  _UploadConfirmInfoState createState() => _UploadConfirmInfoState();
}

class _UploadConfirmInfoState extends State<UploadConfirmInfoWidget> {
  var imagePath = ''.obs;

  final _store = Get.put(ImageController());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return  Obx(() => Column(
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
                  height: widget.isStep4 ? 200.h : 120.h,
                  child: Column(
                    children: [
                      widget.isStep4 ? SizedBox(height: 35.h) : SizedBox(height: 40.h),
                      if (widget.isStep4 && widget.isUploaded != 1) ...[
                        Container(
                          height: 100,
                          child: Image.asset(
                            Assets.identity,
                          ),
                        )
                      ],
                      if (widget.isUploaded != 1) ...[Icon(widget.icon)],
                      Container(
                        child: Text(
                          widget.isUploaded == 1 ? '' : widget.title,
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
                    image: imagePath.value != ''
                        ? new DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: Image.file(
                              File(imagePath.value),
                            ).image,
                          )
                        : null,
                  ),
                ),
                if (widget.isUploaded == 1) ...[
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
    ),
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
                  Padding(padding: EdgeInsets.all(8.0.w)),
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

  _openPicker(ImageSource source, BuildContext context) {
    Future<PickedFile?> _imageFile;
    ImagePicker _picker = new ImagePicker();
    _imageFile = _picker.getImage(source: source);
    _imageFile.then((file) => {_buildState(file)});
    Navigator.of(context).pop();
  }

  _buildState(file) async {
    if (file.path.toString() != '') {
      if (await _store.checkFileUpload(file.path.toString())) {
        imagePath.value = file.path.toString();
        widget.onFileChanged(file.path.toString());
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('avatar_error'.tr)));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
