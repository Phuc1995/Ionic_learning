import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';
import 'package:payment/controllers/transaction_history_controller.dart';
import 'package:payment/dto/dto.dart';
import 'package:payment/service/transaction_history_service.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalendarWiget extends StatefulWidget {
  final TransactionHistoryController transactionHistoryController;
  const CalendarWiget({Key? key, required this.transactionHistoryController})
      : super(key: key);

  @override
  _CalendarWigetState createState() => _CalendarWigetState();
}

class _CalendarWigetState extends State<CalendarWiget> {
  final logger = Modular.get<Logger>();
  final _transactionHistoryService = Modular.get<TransactionHistoryService>();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  DateTime? now = DateTime.now();

  @override
  void initState() {
    this._initDate();
    super.initState();
  }

  _initDate() {
    widget.transactionHistoryController.fromDate.value = formatter
        .format(DateTime(
          now!.year,
          now!.month,
          now!.day - 12,
        ))
        .toString();
    widget.transactionHistoryController.toDate.value =
        formatter.format(now!).toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Obx(
        () => Container(
          margin: EdgeInsets.only(top: 20.h),
          height: 55.h,
          width: double.infinity,
          color: ConvertCommon().hexToColor("#E5E5E5"),
          child: Center(
              child: Text(
                  "${widget.transactionHistoryController.fromDate} ==> ${widget.transactionHistoryController.toDate}")),
        ),
      ),
      onTap: () async {
        _selectDateTime(context);
      },
    );
  }

  _selectDateTime(BuildContext context) async {
    widget.transactionHistoryController.pageCurrent.value = 1;
    DateTimeRange? picked = await showDateRangePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      firstDate: DateTime(now!.year - 5),
      lastDate: DateTime(now!.year + 5),
      initialDateRange: DateTimeRange(
        start: DateTime(
          now!.year,
          now!.month,
          now!.day - 7,
        ),
        end: now!,
      ),
    );
    if (picked!.end.isBefore(now!)) {
      widget.transactionHistoryController.fromDate.value =
          formatter.format(picked.start).toString();
      widget.transactionHistoryController.toDate.value =
          formatter.format(picked.end).toString();
      widget.transactionHistoryController.isLoading.value = true;
      await _transactionHistoryService.getItemTransactionHistory(ItemTransactionHistoryParamDto(
        type: widget.transactionHistoryController.currentItemFiltter.value,
        fromDate: widget.transactionHistoryController.fromDate.value,
        toDate: widget.transactionHistoryController.toDate.value,
        page: widget.transactionHistoryController.pageCurrent.value,
      ))
          .then((result) {
        result.fold(
          (failure) {
            widget.transactionHistoryController.isLoading.value = false;
            ShowErrorMessage().show(
                context: context,
                message: "payment_transaction_filter_message_error".tr);
          },
          (data) {
            widget.transactionHistoryController.isLoading.value = false;
            widget.transactionHistoryController.listItemHistory.value =
                data['items'];
            widget.transactionHistoryController.totalPage.value = data['paging'].totalPages;
          },
        );
      });
    } else {
      ShowErrorMessage().show(
          context: context,
          message: "payment_transaction_filter_message_day_error".tr);
    }
  }
}
