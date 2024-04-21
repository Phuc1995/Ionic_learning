import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:payment/contants/filter_type.dart';
import 'package:payment/controllers/statistic_controller.dart';
import 'package:payment/presentation/pages/statistic_page/widgets/filter_statistic_widget.dart';
import 'package:payment/presentation/pages/statistic_page/widgets/statistic_widget.dart';
import 'package:common_module/presentation/widget/app_bar/app_bar_common.dart';

import 'widgets/calendar_widget.dart';

class StatisticPage extends StatelessWidget {
  const StatisticPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppBarCommonWidget _transactionCommonWidget = AppBarCommonWidget();
    StatisticController _statisticController = Get.put(StatisticController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _transactionCommonWidget.build("payment_statistic_app_bar_title".tr, (){
        _statisticController.typeSelect.value = FilterType.day;
        Modular.to.pop();
      }),
      body: DeviceUtils.buildWidget(context, _buildBody()),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
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
        ),
      ],
    );
  }
}
