import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:live_stream/presentation/pages/live_preview_page/widgets/thumbnail_widget.dart';
import 'package:user_management/domain/entity/response/profile_response.dart';
import 'package:user_management/presentation/controller/image/image_controller.dart';
import 'package:user_management/presentation/widgets/tag_pill.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoomInfoRow extends StatelessWidget {
  final TextEditingController textController;

  final ProfileResponse profile;

  final String storageUrl;

  final List<String> tags;

  final Function() onPressed;

  final Function()? onEditingComplete;

  final SharedPreferenceHelper sharedPrefsHelper;

  const RoomInfoRow({
    Key? key,
    required this.profile,
    required this.sharedPrefsHelper,
    required this.storageUrl,
    required this.tags,
    required this.textController,
    required this.onPressed,
    this.onEditingComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageController imageController = Get.put(ImageController());
    String selectedTagsText = '';
    if (tags.length > 0) {
      String val = '';
      tags.forEach((element) {
        val = val + '\n# ' + element.tr;
      });
      selectedTagsText = 'live_select_tag'.tr + val;
    } else {
      selectedTagsText = 'live_select_tag'.tr;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ThumbnailWidget(
          imageController: imageController,
          storageUrl: storageUrl,
          sharedPrefsHelper: sharedPrefsHelper,
        ),
        SizedBox(
          width: 16.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.gId ?? profile.username,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.sp, color: Colors.white),
              ),
              SizedBox(
                height: 10.h,
              ),
              TagPill(
                tag: selectedTagsText,
                onPressed: this.onPressed,
                colorFill: Colors.black.withOpacity(0.3),
                vertical: 8.h,
                icon: Icons.arrow_forward_ios,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
