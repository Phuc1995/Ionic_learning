import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:payment/contants/assets.dart';
import 'package:get/get.dart';
import 'package:payment/controllers/transaction_history_controller.dart';
import 'package:payment/dto/dto.dart';
import 'package:payment/service/services.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListHistoryTransacion extends StatefulWidget {
  final TransactionHistoryController transactionHistoryController;
  const ListHistoryTransacion(
      {Key? key, required this.transactionHistoryController})
      : super(key: key);

  @override
  _ListHistoryTransacionState createState() => _ListHistoryTransacionState();
}

class _ListHistoryTransacionState extends State<ListHistoryTransacion> {
  final _transactionHistoryService = Modular.get<TransactionHistoryService>();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  DateTime? now = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    this._initData();
    super.initState();
  }

  Future<void> _initData() async {
    String fromDate = formatter
        .format(DateTime(
          now!.year,
          now!.month,
          now!.day - 15,
        ))
        .toString()
        .replaceAll("-", "/");
    String toDate = formatter.format(now!).toString().replaceAll("-", "/");
    await _transactionHistoryService.getItemTransactionHistory(ItemTransactionHistoryParamDto(
      type: 0,
      fromDate: fromDate,
      toDate: toDate,
      page: 1,
    ))
        .then((result) {
      result.fold(
        (failure) => ShowErrorMessage().show(
            context: context,
            message: "payment_transaction_filter_message_error".tr),
        (data) {
          widget.transactionHistoryController.listItemHistory.value = data['items'];
          widget.transactionHistoryController.totalPage.value = data['paging'].totalPages;
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Expanded(
          child: LazyLoadScrollView(
            onEndOfPage: () => loadMore(widget.transactionHistoryController),
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget
                    .transactionHistoryController.listItemHistory.value.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildItemHistory(context, index);
                }),
          ),
        ));
  }

  loadMore(TransactionHistoryController transactionHistoryController) async {
    transactionHistoryController.isLoading.value = true;
    transactionHistoryController.pageCurrent.value +=1;
    int test = 1;
    if(transactionHistoryController.pageCurrent.value < transactionHistoryController.totalPage.value + 1){
      await _transactionHistoryService.getItemTransactionHistory(ItemTransactionHistoryParamDto(
        type: transactionHistoryController.currentItemFiltter.value,
        fromDate: transactionHistoryController.fromDate.value,
        toDate: transactionHistoryController.toDate.value,
        page: transactionHistoryController.pageCurrent.value,
      ))
          .then((result) {
        result.fold(
              (failure) {
            transactionHistoryController.isLoading.value = false;
            ShowErrorMessage().show(
                context: context,
                message: "payment_transaction_filter_message_error".tr);
          } ,
              (data) {
            widget.transactionHistoryController.listItemHistory.value
                .addAll(data['items']);
            transactionHistoryController.isLoading.value = false;
            setState(() {

            });
          },
        );
      });
    }
    else {
      transactionHistoryController.isLoading.value = false;
      ShowShortMessage().show(context: context, message: "edit_user_info_loading_paging".tr, second: 2);
    }

  }

  Widget _buildItemHistory(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(top: 5.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 15,
                child: Container(
                  height: 70.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    _handlerIcon(widget.transactionHistoryController
                        .listItemHistory[index].transactionTypeId),
                  ),
                  margin: EdgeInsets.only(right: 10.w),
                ),
              ),
              Expanded(
                flex: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.transactionHistoryController.listItemHistory[index]
                          .description,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      _convertDate(widget.transactionHistoryController
                          .listItemHistory[index].createdDate),
                      style: TextStyle(
                        color: Colors.black12,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      children: [
                        Text(
                          "payment_transaction_filter_balance".tr + ": ",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        Text(
                          widget.transactionHistoryController
                              .listItemHistory[index].newBalance
                              .toString(),
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Image.asset(
                          Assets.diamondIcon,
                          width: 12.w,
                          height: 12.h,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                  flex: 20,
                  child: Container(
                    margin: EdgeInsets.only(top: 30.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(_convertAmount(widget.transactionHistoryController
                            .listItemHistory[index].amount)),
                        Image.asset(
                          Assets.diamondIcon,
                          width: 18.w,
                          height: 18.h,
                        ),
                      ],
                    ),
                  )),
            ],
          ),
          if (index <
              widget.transactionHistoryController.listItemHistory.value.length -
                  1) ...[Divider(height: 2.h)]
        ],
      ),
    );
  }

  String _handlerIcon(int type) {
    if (type == 2) {
      return Assets.receiveGift;
    }
    return Assets.deposit;
  }

  String _convertDate(String dateServer) {
    print(dateServer);
    var parsedDate = DateTime.parse(dateServer);
    return DateFormat('HH:mm:ss dd/MM/yyyy').format(parsedDate.toLocal());
  }

  String _convertAmount(int amount) {
    if (!amount.isNegative) {
      return "+${amount.toString()}";
    }
    return amount.toString();
  }
}
