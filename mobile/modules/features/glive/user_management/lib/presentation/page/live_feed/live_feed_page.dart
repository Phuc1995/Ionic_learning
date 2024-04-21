import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_management/constants/assets.dart';
import 'package:user_management/controllers/notification_controller.dart';
import 'widget/app_bar_widget.dart';
import 'widget/list_feed_widget.dart';
import 'widget/slider_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class LiveFeedSPage extends StatefulWidget {
  Function? onRefresh;

  LiveFeedSPage({
    Key? key,
    this.onRefresh,
  }) : super(key: key);

  _LiveFeedSPageState createState() => _LiveFeedSPageState();
}

class _LiveFeedSPageState extends State<LiveFeedSPage> {
  ScrollController _scrollController = ScrollController();
  NotificationController _notificationController = Get.put(NotificationController());
  ScrollController _toolbarScrollController = ScrollController();
  double _patternHeight = 160.h;
  double _patternRadius = 80.r;
  bool loading = false;
  String storageUrl = '';

  final List<String> imgList = [
    Assets.banner1,
    Assets.banner1,
    Assets.banner1,
    Assets.banner1,
    Assets.banner1,
  ];

  Future<void> _refreshInfo() async {
    if (widget.onRefresh != null) {
      widget.onRefresh!();
    }
    _notificationController.countUnreadNotification().then((value) {
      value.fold((l) => null, (number) => _notificationController.unreadNotification.value = number); });
  }

  @override
  initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
    this._refreshInfo();
  }
  @override
  dispose() {
     _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    double appBarHeight = MediaQuery.of(context).padding.top + kToolbarHeight;
    double appBarPosition = 40;
    if (_scrollController.offset >= appBarPosition) {
      setState(() {
        _patternHeight = appBarHeight;
        _patternRadius = 0;
      });
    } else {
      setState(() {
        _patternHeight = 160.h;
        _patternRadius = 80.r;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppbarWidget().appBar(),
            body: DeviceUtils.buildWidget(context, _buildBody()),
          ),
          Visibility(
            visible: loading,
            child: CustomProgressIndicatorWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
        color: Colors.transparent,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SliderWidget(
                images: imgList,
              ),
              ListFeedWidget(),
            ],
          ),
        ));
  }
}
