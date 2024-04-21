import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/presentation/controller/report/report_controller.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImagesWidget extends StatefulWidget {
  const ImagesWidget({Key? key}) : super(key: key);

  @override
  _ImagesWidgetState createState() => _ImagesWidgetState();
}

class _ImagesWidgetState extends State<ImagesWidget> {
  final ReportController _reportController =  Get.put(ReportController());
  List<Asset> images = <Asset>[];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.w, top: 10.h),
          child: Text("report_images_title".tr, style: TextUtils.textStyle(FontWeight.w500, 16.sp),),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.w, top: 20.h, right: 0.w),
          child: Row(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                    color: AppColors.whiteSmoke2,
                    borderRadius: BorderRadius.circular(5.r)
                ),
                child: IconButton(
                  icon: Icon(Icons.add),
                  iconSize: 50.sp,
                  color: AppColors.whiteSmoke10,
                  onPressed: (){
                    loadAssets();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.w, top: 0.h, right: 15.w),
                child: images.isEmpty ? Container(
                  child: Column(
                      children: [
                      Container(
                        width: 230.w,
                        child: Text("report_images_content1".tr, style: TextUtils.textStyle(FontWeight.w400, 13.sp), textAlign: TextAlign.left,),
                      ),
                      Container(
                        width: 230.w,
                        height: 100.h,
                        child: Text("report_images_content2".tr, style: TextUtils.textStyle(FontWeight.w400, 13.sp), textAlign: TextAlign.left)
                      )
                    ],
                  ),
                ) : Container(
                  height: 140.h,
                  width: 250.w,
                  child: GridView.count(
                    crossAxisCount: 5,
                    children: List.generate(images.length, (index) {
                      Asset asset = images[index];
                      return AssetThumb(
                        asset: asset,
                        width: 100.w.toInt(),
                        height: 100.h.toInt(),
                      );
                    }),
                  ),
                ),
              )
            ],
          ),
        ),

      ],
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: false,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
    }
    if (!mounted) return;
    setState(() {
      images = resultList;
    });
  }

}
