import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:payment/contants/filter_type.dart';
import 'package:payment/controllers/statistic_controller.dart';
import 'package:payment/presentation/pages/statistic_page/widgets/filter_statistic_widget.dart';
import 'package:payment/presentation/pages/statistic_page/widgets/statistic_widget.dart';

import 'widgets/calendar_widget.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({Key? key}) : super(key: key);

  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  AppBarCommonWidget _transactionCommonWidget = AppBarCommonWidget();
  StatisticController _statisticController = Get.put(StatisticController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _statisticController.typeSelect.value = FilterType.day;
    _statisticController.resetFilterController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _transactionCommonWidget.build("payment_statistic_app_bar_title".tr, (){
        Modular.to.pop();
      }),
      body: DeviceUtils.buildWidget(context, _buildBody()),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Obx(() =>  Visibility(
            visible: !_statisticController.isNoNetwork.value,
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Statistic(),
                  CalendarWiget(),
                  ListFilterStatisticWidget(),
                ],
              ),
            ),
          )),
          Obx(() =>  Visibility(
            visible: _statisticController.isNoNetwork.value,
            child: NetworkUtil.NoNetworkWidget(asyncCallback: () => _statisticController.getDataStatistic(context)),
          )),
        ],
      ),
    );
  }
}
