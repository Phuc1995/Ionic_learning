import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_stream/constants/constants.dart';
import 'package:live_stream/dto/dto.dart';
import 'package:live_stream/services/services.dart';

class AllListManage extends StatefulWidget {
  final Rx<LiveMessageDto> liveMessage;
  final String storageUrl;

  const AllListManage(
      {Key? key, required this.liveMessage, required this.storageUrl})
      : super(key: key);

  @override
  _AllListManageState createState() => _AllListManageState();
}

class _AllListManageState extends State<AllListManage> {
  var listData = <ViewerPermissionDto>[].obs;
  ScrollController _scrollController = ScrollController();
  var totalPage = 1.obs;
  var currentPage = 1.obs;
  var typeSelect = ViewerPermissionType.LIVE_ROOM_MANAGER.obs;
  LiveStreamService liveStreamService = Modular.get<LiveStreamService>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (currentPage.value >= totalPage.value) {} else {
          currentPage += 1;
          getData();
        }
      }
    });
    getData();
  }

  getData() async{
    final liveService = Modular.get<LiveStreamService>();
    var data = await liveService.getListViewerPermission(ListViewerPermissionDto(limit: 20, title: typeSelect.value, page: currentPage.value));
    data.fold((l) => (){}, (data) {{
      listData.addAll(data['items']);
      totalPage.value = data['totalPages'];
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    var isCensor = false.obs;
    var isLimitUser = false.obs;
    if (widget.liveMessage.value.permission.contains(
        ViewerPermissionType.LIVE_ROOM_MANAGER)) {
      isCensor.value = true;
    }
    if (widget.liveMessage.value.permission.contains(
        ViewerPermissionType.LIVE_ROOM_LOCKED_CHAT)) {
      isLimitUser.value = true;
    }
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 500.h,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                height: 75.h,
                child: Row(children: [
                  IconButton(icon: Icon(Icons.arrow_back_ios, size: 25.sp, color: AppColors.whiteSmoke), onPressed: (){
                    Navigator.pop(context);
                  },),
                  SizedBox(width: 10.w,),
                  InkWell(child: Obx(() => Text("live_manage_censor".tr, style: TextUtils.textStyle(FontWeight.w600, 20.sp,
                      color: typeSelect.value == ViewerPermissionType.LIVE_ROOM_MANAGER ? AppColors.grayCustom2 : AppColors.whiteSmoke),),),
                  onTap: (){
                    if(typeSelect.value != ViewerPermissionType.LIVE_ROOM_MANAGER){
                      _changeType(ViewerPermissionType.LIVE_ROOM_MANAGER);
                      _resetData();
                      getData();
                    }
                  },),
                  SizedBox(width: 40.w,),
                  InkWell(child: Obx(() => Text("live_manage_limit_list_button".tr,
                      style: TextUtils.textStyle(FontWeight.w600, 20.sp,
                      color: typeSelect.value == ViewerPermissionType.LIVE_ROOM_LOCKED_CHAT ?AppColors.grayCustom2 : AppColors.whiteSmoke ),),),
                  onTap: (){
                    if(typeSelect.value != ViewerPermissionType.LIVE_ROOM_LOCKED_CHAT){
                      _changeType(ViewerPermissionType.LIVE_ROOM_LOCKED_CHAT);
                      _resetData();
                      getData();
                    }
                  },)
                ],),
              ),
            ),
            Divider(thickness: 5.h, color: AppColors.whiteSmoke11,),
            Obx(() => Container(
              height: 400.h,
              child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: listData.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildItem(index);
              },
          ),
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildItem(int index){
    return
      Container(child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(widget.storageUrl + listData[index].imageUrl)),
        title: Text(listData[index].fullName, style: TextUtils.textStyle(FontWeight.w600, 16.sp, color: AppColors.grayCustom2),),
        trailing: Container(
          child: TextButton(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all<Size>(
                  Size.fromWidth(100.w),
              ),
              shape:  MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.r),
                  )
              ),
              padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.only(top: 5.h, bottom: 5.h, right: 20.w, left: 20.w),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(AppColors.pinkLiveButtonCustom),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
              onPressed: (){
                if(typeSelect.value == ViewerPermissionType.LIVE_ROOM_MANAGER){
                  ShowDialog().showMessage(context, listData[index].fullName + "live_manage_censor_remove_title".tr, "live_manage_confirm_button".tr, () async {
                    final response = await liveStreamService.addViewerPermission(AddViewerPermissionDto(title: ViewerPermissionType.LIVE_ROOM_MANAGER, userUuid: listData[index].userUuid, isRemove: true));
                    response.fold((l) => null, (r) {
                      ShowShortMessage().showTop(context: context, message: listData[index].fullName + "live_manage_censor_remove_show_message".tr, messageColor: Colors.white, backgroundColor: AppColors.pinkLiveButtonCustom);
                      if(widget.liveMessage.value.id == listData[index].userUuid){
                        widget.liveMessage.value.isManager = false;
                        widget.liveMessage.refresh();
                      }
                      _resetData();
                      getData();
                      Navigator.pop(context);
                    });
                  }, textButton2: "live_manage_cancel_button".tr, onButton2: (){
                    Navigator.pop(context);
                  });
                } else {
                  ShowDialog().showMessage(context, listData[index].fullName + "live_manage_limit_remove_title".tr, "live_manage_confirm_button".tr, () async {
                    final response = await liveStreamService.addViewerPermission(AddViewerPermissionDto(title: ViewerPermissionType.LIVE_ROOM_LOCKED_CHAT, userUuid: listData[index].userUuid, isRemove: true));
                    response.fold((l) => null, (r) {
                      ShowShortMessage().showTop(context: context, message: listData[index].fullName + "live_manage_limit_remove_message".tr, messageColor: Colors.white, backgroundColor: AppColors.pinkLiveButtonCustom);
                      if(widget.liveMessage.value.id == listData[index].userUuid){
                        widget.liveMessage.value.isLocked = false;
                        widget.liveMessage.refresh();
                      }
                      _resetData();
                      getData();
                      Navigator.pop(context);
                    });
                  }, textButton2: "live_manage_cancel_button".tr, onButton2: (){
                    Navigator.pop(context);
                  });
                }
              },
            child: Text('live_manage_remove_button'.tr, style: TextUtils.textStyle(FontWeight.w600, 14.sp, color: Colors.white),),
          ),
        )
      ),);
  }

  void _changeType(String type) {
    typeSelect.value = type;
  }

  void _resetData() {
    listData.value = [];
    totalPage.value = 1;
    currentPage.value = 1;
  }
}




