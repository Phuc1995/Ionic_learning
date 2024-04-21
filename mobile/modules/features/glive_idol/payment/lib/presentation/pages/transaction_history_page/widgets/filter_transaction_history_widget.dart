import 'package:common_module/common_module.dart';
import 'package:payment/dto/dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:payment/controllers/transaction_history_controller.dart';
import 'package:payment/services/services.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterTransactionHistoryWidget extends StatefulWidget {
  final TransactionHistoryController transactionHistoryController;
  const FilterTransactionHistoryWidget(
      {Key? key, required this.transactionHistoryController})
      : super(key: key);

  @override
  _FilterTransactionHistoryWidgetState createState() =>
      _FilterTransactionHistoryWidgetState();
}

class _FilterTransactionHistoryWidgetState
    extends State<FilterTransactionHistoryWidget> {
  var listItemFilter = <Widget>[].obs;
  ConvertCommon convertCommon = ConvertCommon();
  final logger = Modular.get<Logger>();
  @override
  void initState() {
    widget.transactionHistoryController.isLoading.value = true;
    this._getTransactionTypes();
    super.initState();
  }

  Future<void> _getTransactionTypes() async {
    final transactionHistoryService = Modular.get<TransactionHistoryService>();
    final either = await transactionHistoryService.getTransactionTypes();
    either.fold((failure) {
      widget.transactionHistoryController.isLoading.value = false;
      ShowErrorMessage().show(
          context: context,
          message: "payment_transaction_filter_message_error".tr);
    }, (data) {
      data.remove(1);
      data.remove(3);
      widget.transactionHistoryController.listItemFilter.value = data;
      widget.transactionHistoryController.listItemFilter.value
          .forEach((key, value) {
        listItemFilter.add(
          _buildItemFilter(key, value),
        );
        widget.transactionHistoryController.isLoading.value = false;
      });
    });
  }

  Widget _buildItemFilter(int key, String value) {
    return Row(
      children: [
        Obx(
          () => Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: widget.transactionHistoryController.currentItemFiltter
                              .value ==
                          key
                      ? convertCommon.hexToColor("#DD2863")
                      : convertCommon.hexToColor("#DADADA")),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: TextButton(
              onPressed: () async {
                widget.transactionHistoryController.pageCurrent.value = 1;
                widget.transactionHistoryController.isLoading.value = true;
                widget.transactionHistoryController.currentItemFiltter.value =
                    key;
                final service = Modular.get<TransactionHistoryService>();
                await service.getTransactionHistory(TransactionHistoryParamDto(
                        type: widget.transactionHistoryController
                            .currentItemFiltter.value,
                        fromDate:
                            widget.transactionHistoryController.fromDate.value,
                        toDate:
                            widget.transactionHistoryController.toDate.value,
                        page: widget.transactionHistoryController.pageCurrent.value))
                    .then((result) {
                  result.fold(
                    (failure) {
                      widget.transactionHistoryController.isLoading.value =
                          false;
                      ShowErrorMessage().show(
                          context: context,
                          message:
                              "payment_transaction_filter_message_error".tr);
                    },
                    (data) {
                      widget.transactionHistoryController.listItemHistory
                          .value = data['items'];
                      widget.transactionHistoryController.totalPage.value = data['paging'].totalPages;
                      widget.transactionHistoryController.isLoading.value =
                          false;
                    },
                  );
                });
              },
              child: Text(
                value.tr,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 5.w,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        child: Obx(
          () => ListView(
            scrollDirection: Axis.horizontal,
            children: listItemFilter,
          ),
        ));
  }
}
