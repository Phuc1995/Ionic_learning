import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_management/controllers/follow_controller.dart';
import 'package:user_management/presentation/page/follow_page/widget/following_list_widget.dart';
import 'package:user_management/presentation/page/follow_page/widget/idol_streaming_widget.dart';

class FlowingPage extends StatefulWidget {
  const FlowingPage({Key? key}) : super(key: key);

  @override
  State<FlowingPage> createState() => _FlowingPageState();
}

class _FlowingPageState extends State<FlowingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCommonWidget().build('follow_title'.tr, (){
      }, isShowBack: false) ,
      body: DeviceUtils.buildWidget(context, _buildBody()),
    );
  }

  Widget _buildBody() {
    FollowController _followController = Get.put(FollowController());
    return RefreshIndicator(
      onRefresh: () async {
        _followController.resetPaging();
        _followController.getIdolList();
        _followController.getIdolStreaming();
      },
      child: ListView(
        children: [
          IdolStreamingWidget(),
          FollowingListWidget(),
        ],
      ),
      );
  }
}
