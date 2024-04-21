import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:live_stream/constants/size_gift.dart';
import 'package:live_stream/dto/gift_dto.dart';
import 'package:live_stream/controllers/live_stream_controller.dart';
import 'package:logger/logger.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marquee/marquee.dart';
import 'package:get/get.dart';

class ShowMessageGiftWidget extends StatefulWidget {
  final LiveStreamController liveController;
  final String storageUrl;

  const ShowMessageGiftWidget({
    Key? key,
    required this.liveController,
    required this.storageUrl,
  }) : super(key: key);

  @override
  _ShowMessageGiftWidgetState createState() => _ShowMessageGiftWidgetState();
}

class _ShowMessageGiftWidgetState extends State<ShowMessageGiftWidget> {
  late double iconWidth = 200;
  bool isLoad = false;
  late Timer _timer;
  late List<GiftDto> gift = [];
  final logger = Modular.get<Logger>();
  bool isShow = true;

  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 5000), (timer) async {
      List<GiftDto> data = widget.liveController.getAllGift();
      setState(() {
        isShow = true;
        gift = [];
        if (data.length > 0) {
          gift.add(data[0]);
          widget.liveController.removeGift(0);
        }
      });
      Future.delayed(const Duration(milliseconds: 3000), () {
        if (mounted) {
          setState(() {
            isShow = false;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (gift.length > 0 && gift[0].giftImage != '')
        ? CachedNetworkImage(
            imageUrl: widget.storageUrl + gift[0].giftAnimation,
            imageBuilder: (context, imageProvider) => AnimatedOpacity(
              duration: Duration(milliseconds: 1000),
              opacity: isShow ? 1 : 0,
              curve: Curves.ease,
              child: Row(
                children: [
                  Container(
                    height: 60.h,
                    width: 180.w,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.pink1, width: 1.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().radius(40.r)),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                gradient: AppColors.pinkGradientBox,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 22.w, top: 13.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 0.w),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100.r),
                                    ),
                                    width: 100.w,
                                    height: 20.h,
                                    child: gift[0].userName.length > 12
                                        ? Marquee(
                                            text: gift[0].userName,
                                            blankSpace: 20.0.w,
                                            style: TextUtils.textStyle(FontWeight.w500, 15.sp,
                                                color: AppColors.yellow1),
                                            startAfter: Duration(seconds: 1),
                                            velocity: 15.0,
                                          )
                                        : Text(
                                            gift[0].userName,
                                            style: TextUtils.textStyle(FontWeight.w500, 15.sp,
                                                color: AppColors.yellow1),
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Container(
                                width: 100.w,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 0.w, bottom: 2.h),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100.r),
                                    ),
                                    width: 90.w,
                                    height: 20.h,
                                    child: ('live_give_gift'.tr + ' ' + gift[0].giftName).length >
                                            15
                                        ? Marquee(
                                            text: ('live_give_gift'.tr + ' ' + gift[0].giftName),
                                            blankSpace: 20.0.w,
                                            style: TextUtils.textStyle(FontWeight.w300, 12.sp,
                                                color: Colors.white),
                                            startAfter: Duration(seconds: 1),
                                            velocity: 15.0,
                                          )
                                        : Text(
                                            ('live_give_gift'.tr + ' ' + gift[0].giftName),
                                            style: TextUtils.textStyle(FontWeight.w300, 12.sp,
                                                color: Colors.white),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 13.h,
                          right: 20.w,
                          height: 35.h,
                          width: 35.w,
                          child: gift.length > 0 && gift[0].giftImage != ''
                              ? Container(
                                  child: Image(image: imageProvider,),
                                )
                              : Container(),
                        ),
                        Positioned(
                          bottom: 7.h,
                          right: -50.w,
                          height: 35.h,
                          width: 35.w,
                          child: Text(
                            'x' + gift[0].quantity,
                            style: TextUtils.textStyle(FontWeight.w700, 18.sp, color: Colors.white),
                          ),
                        ),
                        Positioned(
                          bottom: gift[0].size == SizeGift.large
                              ? -MediaQuery.of(context).size.height * 0.5
                              : MediaQuery.of(context).size.height * 0.2,
                          left: gift[0].size == SizeGift.large
                              ? 0
                              : MediaQuery.of(context).size.width * 0.4,
                          height: gift[0].size == SizeGift.large
                              ? MediaQuery.of(context).size.height
                              : 150.h,
                          width: gift[0].size == SizeGift.large
                              ? MediaQuery.of(context).size.width
                              : 150.h,
                          child: gift.length > 0 &&
                                  gift[0].giftImage != '' &&
                                  gift[0].size != SizeGift.small
                              ? Container(
                                  foregroundDecoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill),
                                  ),
                                )
                              : Container(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            placeholder: (context, url) => Container(),
          )
        : Container();
  }
}
