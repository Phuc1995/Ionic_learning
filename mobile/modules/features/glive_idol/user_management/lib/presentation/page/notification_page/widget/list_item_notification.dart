import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/constants/assets.dart';
import 'package:user_management/constants/notification_filter_type.dart';
import 'package:user_management/domain/usecase/notification/tick_was_read.dart';
import 'package:user_management/presentation/controller/notification/notification_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListItemNotification extends StatefulWidget {
  @override
  _ListItemNotificationState createState() => _ListItemNotificationState();
}

class _ListItemNotificationState extends State<ListItemNotification> {
  NotificationController _notificationController = Get.put(NotificationController());
  ScrollController _scrollController = ScrollController();
  late SharedPreferenceHelper _sharedPrefsHelper = Modular.get<SharedPreferenceHelper>();
  late Future<void> _initializeControllerFuture;
  late final String storageUrl;

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
      _initSharedPrefs(),
    ]);

  }

  Future<void> _initSharedPrefs() async {
    storageUrl = _sharedPrefsHelper.storageServer + '/' + _sharedPrefsHelper.bucketName + '/';
    _notificationController.getData(context);
    _notificationController.countUnreadNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() =>  Visibility(
          visible: !_notificationController.isNoNetwork.value,
          child: Container(
            height: ScreenUtil().screenHeight - 180.h,
            child: _buildListItem(context),
          ),
        )),
        Obx(() =>  Visibility(
          visible: _notificationController.isNoNetwork.value,
          child: NetworkUtil.NoNetworkWidget(asyncCallback: () => _notificationController.getData(context)),
        )),
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
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 5.h, top: 5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                width: 24.w,
                height: 24.h,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: constraints.maxWidth.floor() - 75.w,
                  child: Text(
                    _notificationController.listData[index].title,
                    style: TextUtils.textStyle(FontWeight.w600, 16.sp, color: _notificationController.listData[index].read ? AppColors.whiteSmoke6 : AppColors.grayCustom),
                  )
                ),

                Container(
                  width: constraints.maxWidth.floor() - 75.w,
                  padding: EdgeInsets.only(top: 5.h),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _notificationController.listData[index].createdDate,
                    textAlign: TextAlign.left,
                    style: TextUtils.textStyle(FontWeight.w400, 12.sp, color: _notificationController.listData[index].read ? AppColors.whiteSmoke9 : AppColors.grayCustom1),
                  ),
                ),
              ]
            ),

          ],
        ),
      );
    });

  }

  Widget _createListItem(BuildContext context, int index) {
    return InkWell(
      onTap: (){
        if(!_notificationController.listData[index].read){
          TickWasReadNotification().call(
              TickWasReadNotificationParam(
                id: _notificationController.listData[index].id,
                read: _notificationController.listData[index].read,
              )).then((value) {
            value.fold((l) => null, (r) {
              _notificationController.listData[index].read = true;
              if(_notificationController.typeSelect.value == NotificationFilterType.UNREAD){
                _notificationController.listData.removeAt(index);
              }
              _notificationController.listData.refresh();
              _notificationController.unreadNotification.value = _notificationController.unreadNotification.value - 1;
            });
          });
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
                  padding: EdgeInsets.only(left: 54.w, top: 5.h, bottom: 10.h, right: 10.w),
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
