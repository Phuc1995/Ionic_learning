import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:level/controllers/controllers.dart';
import 'package:level/presentation/pages/level_detail_page/widget/banner_level_widget.dart';
import 'package:level/presentation/pages/level_detail_page/widget/level_detail_widget.dart';
import 'package:level/presentation/pages/level_detail_page/widget/text_info_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LevelDetailPage extends StatelessWidget {
  const LevelDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppBarCommonWidget appBarCommonWidget = AppBarCommonWidget();
    return Scaffold(
      appBar: appBarCommonWidget.build("level_appbar_title",  (){
        Modular.to.pop();
      }),
      body: DeviceUtils.buildWidget(context, _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    LevelDetailController _levelDetailController = Get.put(LevelDetailController());
    return RefreshIndicator(
      onRefresh: () async {
        _levelDetailController.refreshIdolExperience(context);
      },
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Obx(() =>  Visibility(
                visible: !_levelDetailController.isNoNetwork.value,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 254.h,
                      margin: EdgeInsets.only(top: 30.h, left: 15.w, right: 15.w),
                      child: BannerLevelWidget(),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.h, left: 15.w, right: 15.w),
                      child: TextInfo(),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30.h, left: 0.w, right: 0.w),
                      child: LevelDetailWidget(),
                    ),
                    // Container(
                    //   margin: const EdgeInsets.fromLTRB(47, 50, 47, 50),
                    //   child: ButtonLevelDetailWidget(),
                    // ),
                  ],
                ),
              )),
              Obx(() =>  Visibility(
                visible: _levelDetailController.isNoNetwork.value,
                child: NetworkUtil.NoNetworkWidget(asyncCallback: () => _levelDetailController.refreshIdolExperience(context)),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
