import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:payment/contants/assets.dart';
import 'package:payment/controllers/transaction_history_controller.dart';
import 'package:payment/presentation/pages/transaction_history_page/widgets/filter_transaction_history_widget.dart';
import 'package:payment/presentation/pages/transaction_history_page/widgets/list_history_transaction_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/calendar_widget.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TransactionHistoryController _transactionHistoryController = Get.put(TransactionHistoryController());
    AppBarCommonWidget _transactionCommonWidget = AppBarCommonWidget();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _transactionCommonWidget.build(
          "payment_transaction_history_app_bar_title", (){
        Modular.to.pop();
      }, action: InkWell(
        onTap: (){

        },
        child: Container(
          child: Image.asset(Assets.historyIcon),
        ),
      )),
      body: DeviceUtils.buildWidget(context, _buildBody(_transactionHistoryController)),
    );
  }

  Widget _buildBody(TransactionHistoryController transactionHistoryController) {
    return Stack(children: <Widget>[
      Center(
          child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(25.w, 25.h, 25.w, 25.h),
        child: Column(
          children: <Widget>[
            FilterTransactionHistoryWidget(transactionHistoryController: transactionHistoryController),
            CalendarWiget(transactionHistoryController: transactionHistoryController),
            ListHistoryTransacion(transactionHistoryController: transactionHistoryController,),
          ],
        ),
      )),
      Obx(() => Visibility(
        visible: transactionHistoryController.isLoading.value,
        child: CustomProgressIndicatorWidget(),
      )),
    ]);
  }
}
