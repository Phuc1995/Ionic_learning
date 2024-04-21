import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:live_stream/controllers/camera_live_controller.dart';
import 'package:live_stream/controllers/live_stream_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_stream/services/services.dart';

class RoomInfoBar extends StatelessWidget {
  final Function? onSwitchCamera;

  final Widget? child;

  const RoomInfoBar({
    Key? key,
    this.onSwitchCamera,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LiveStreamController liveController = Get.put(LiveStreamController());
    final CameraLiveController cameraLiveController = Get.put(CameraLiveController());
    LiveStreamService _liveApi = Modular.get<LiveStreamService>();
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 32.h, right: 8.w),
              child: GestureDetector(
                child: IconButton(
                  color: Colors.white70,
                  icon: new Icon(Icons.flip_camera_ios_outlined),
                  iconSize: 32.sp,
                  onPressed: () => {
                    if (this.onSwitchCamera != null) {this.onSwitchCamera!()}
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 32.h, right: 8.w),
              child: GestureDetector(
                child: IconButton(
                  color: Colors.white70,
                  icon: new Icon(Icons.close),
                  iconSize: 32.sp,
                  onPressed: () async {
                    if (cameraLiveController.streamId.value != "") {
                      await _liveApi.endLiveSession(
                          liveController.liveId.value,
                          cameraLiveController.streamId.value);
                    }
                    Modular.to.pushReplacementNamed(IdolRoutes.user_management.home);
                  }),
              ),
            ),
          ]),
          Padding(padding: EdgeInsets.only(top: 12.h, left: 24.w, right: 32.w), child: this.child)
        ],
      ),
    );
  }
}
