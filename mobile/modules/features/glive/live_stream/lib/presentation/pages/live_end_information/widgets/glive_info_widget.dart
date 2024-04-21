import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:live_stream/presentation/controller/live/live_controller.dart';
import 'package:user_management/constants/assets.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/presentation/page/live_feed/widget/build_item_live_widget.dart';

class GliveInfoWidget extends StatelessWidget {
  const GliveInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _storageUrl = Modular.get<SharedPreferenceHelper>().storageServer + '/' + Modular.get<SharedPreferenceHelper>().bucketName + '/';
    LiveController _liveController = Get.put(LiveController());
    _liveController.settingRoomSuggest();
    return GridView.builder(
      physics: ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.w,
        mainAxisExtent: 190.h,
      ),
      itemCount: _liveController.listSuggest.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext ctx, index) {
        if(_liveController.currentRoomIndex.value == _liveController.listRoom.length){
          index = index;
        } else {
          index = index + _liveController.currentRoomIndex.value;
        }
        ImageProvider img = AssetImage(Assets.defaultAvatar);
        if (_liveController.listRoom[index].thumbnail != '') {
          try {
            img = NetworkImage(_storageUrl + _liveController.listRoom[index].thumbnail.toString() );
          } catch (err) {
            img = AssetImage(Assets.defaultAvatar);
          }
        }
        return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              image: DecorationImage(
                scale: 2/3,
                image: img,
                fit: BoxFit.cover,
              ),
            ),
            child: BuildItemLiveWidget().build(index, true, context)
        );
      },
    );
  }
}

