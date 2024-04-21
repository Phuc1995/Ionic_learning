import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/controllers/notification_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants/assets.dart';

class ListItemNotification extends StatefulWidget {
  @override
  _ListItemNotificationState createState() => _ListItemNotificationState();
}

class _ListItemNotificationState extends State<ListItemNotification> {
  NotificationController _notificationController = Get.put(NotificationController());
  ScrollController _scrollController = ScrollController();
  late SharedPreferenceHelper _sharedPrefsHelper = Modular.get<SharedPreferenceHelper>();
  late Future<void> _initializeControllerFuture;
  late final String storageUrl = _sharedPrefsHelper.getStorageUrl();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _notificationController.resetAllController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_notificationController.currentPage.value >=
            _notificationController.totalPage.value) {
          ShowShortMessage().show(
              context: context, message: "payment_statistic_loading_paging".tr, second: 2);
        } else {
          _notificationController.isLoading.value = true;
          _notificationController.currentPage += 1;
          _notificationController.getData(context);
        }
      }
    });
    _initializeControllerFuture = Future.wait([
      _notificationController.getData(context),
      _notificationController.countUnreadNotification(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: ScreenUtil().screenHeight - 180.h,
          child: _buildListItem(context),
        ),
       Obx(() =>  Visibility(
         visible: _notificationController.isNoNetwork.value,
         child: NetworkUtil.NoNetworkWidget(asyncCallback: () => _notificationController.getData(context)),
       ))
      ],
    );
  }

  Widget _buildListItem(BuildContext context) {
    return Obx(() => ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: _notificationController.listData.length,
      itemBuilder: (BuildContext context, int index) {
        return _createListItem(
            context, index);
      },
    ));
  }

  Widget _buildTitleItem(int index) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h, top: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                  width: 24.h,
                  height: 24.w,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(_notificationController.listData[index].read ? 0.4 : 1), BlendMode.dstIn),
                    child: ImageCachedNetwork(
                      fileUrl: _notificationController.listData[index].imageUrl,
                      storageUrl: storageUrl,
                      defaultAvatar: Assets.appIcon,
                      boxFit: BoxFit.fill,
                    ),
                  )
              ),
              SizedBox(width: 10.w,),
              Container(
                  width: 200.w,
                  child: Text(_notificationController.listData[index].title, style: TextUtils.textStyle(FontWeight.w600, 16.sp, color: _notificationController.listData[index].read ? AppColors.whiteSmoke6 : AppColors.grayCustom),))
            ],
          ),
          SizedBox(width: 10.w,),
          Container(
            width: 125.w,
            child: FittedBox(
                fit: BoxFit.contain,
                child: Text(_notificationController.listData[index].createdDate, style: TextUtils.textStyle(FontWeight.w400, 12.sp, color: _notificationController.listData[index].read ? AppColors.whiteSmoke9 : AppColors.grayCustom1),)),
          )
        ],
      ),
    );
  }

  Widget _createListItem(BuildContext context, int index) {
    return InkWell(
      onTap: (){
        if(!_notificationController.listData[index].read){
          _notificationController.tickWasReadNotification(
            id: _notificationController.listData[index].id,
            read: _notificationController.listData[index].read,
            index: index,
          );
        }
      },
          child: Obx(() => Container(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(thickness: 5.h, color: AppColors.whiteSmoke5,),
              _buildTitleItem(index),
              Divider(thickness: 1.h, color: AppColors.whiteSmoke2,),
              Container(
                child: Padding(
                  padding: EdgeInsets.only(left: 50.w, top: 10.h, bottom: 20.h, right: 10.w),
                  child: Text(_notificationController.listData[index].content,
                    textAlign: TextAlign.left,
                    style: TextUtils.textStyle(
                      FontWeight.w600 ,
                      12.sp,
                      color: _notificationController.listData[index].read ? AppColors.whiteSmoke6 : AppColors.grayCustom1,),),
                ),
              ),
            ],
          ),
    )),
        );
  }

}
