import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_stream/presentation/controller/live/live_controller.dart';
import 'package:user_management/constants/assets.dart';
import 'package:user_management/dto/dto.dart';

import 'build_item_live_widget.dart';

class ListFeedWidget extends StatefulWidget {
  const ListFeedWidget({Key? key}) : super(key: key);

  @override
  _ListFeedWidgetState createState() => _ListFeedWidgetState();
}

class _ListFeedWidgetState extends State<ListFeedWidget> {

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     String storageUrl = Modular.get<SharedPreferenceHelper>().getStorageUrl();
     LiveController liveController = Get.put(LiveController());
     ViewerLiveRoomDto room = ViewerLiveRoomDto();
     return Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Column(
        children: [
          StreamBuilder(
            stream: FirebaseStorage.getLiveRoom(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData && !snapshot.hasError && snapshot.data.snapshot.value != null) {
                Map<dynamic, dynamic> snapshotMap = Map<dynamic, dynamic>.from(snapshot.data.snapshot.value);
                List<ViewerLiveRoomDto> listRoomTmp = [];
                snapshotMap.forEach((key, value) {
                  room = ViewerLiveRoomDto.fromMap(value[FirebaseStorage.metaData]);
                  room.ruby = value[FirebaseStorage.ruby];
                  room.viewCount = value[FirebaseStorage.viewCount];
                  if(listRoomTmp.length > 0){
                    int index = listRoomTmp.indexWhere((data) => data.id == room.id);
                    if(!(index > -1)){
                      listRoomTmp.add(room);
                    }
                  }else{
                    listRoomTmp.add(room);
                  }
                });
                liveController.listRoom.value = listRoomTmp;
                liveController.listRoom.refresh();
               return GridView.builder(
                  physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.w,
                    mainAxisExtent: 190.h,
                  ),
                  itemCount: liveController.listRoom.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext ctx, index) {
                    ImageProvider img = AssetImage(Assets.defaultAvatar);
                    if (liveController.listRoom[index].thumbnail != '') {
                      try {
                        img = NetworkImage(storageUrl + liveController.listRoom[index].thumbnail.toString() );
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
                      child: BuildItemLiveWidget().build(index,false, context)
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
