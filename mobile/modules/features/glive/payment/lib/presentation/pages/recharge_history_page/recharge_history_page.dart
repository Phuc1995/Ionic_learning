import 'package:common_module/common_module.dart';
import 'package:common_module/presentation/widget/app_bar/app_bar_common.dart';
import 'package:common_module/presentation/widget/progress_indicator/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment/contants/assets.dart';
import 'package:payment/controllers/recharge_history_controller.dart';
import 'package:payment/presentation/pages/recharge_history_page/widget/filter_network_widget.dart';
import 'package:payment/presentation/pages/recharge_history_page/widget/filter_status_widget.dart';
import 'package:payment/presentation/pages/recharge_history_page/widget/filter_time_widget.dart';

class RechargeHistoryPage extends StatefulWidget {
  const RechargeHistoryPage({Key? key}) : super(key: key);

  @override
  _RechargeHistoryPageState createState() => _RechargeHistoryPageState();
}

class _RechargeHistoryPageState extends State<RechargeHistoryPage> {
  RechargeHistoryController _controller = Get.put(RechargeHistoryController());
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    _controller.resetAllController();
    _controller.getNetworks();
    _controller.getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_controller.currentPage.value >=
            _controller.totalPage.value) {
          ShowShortMessage().show(
              context: context, message: "payment_statistic_loading_paging".tr, second: 2);
        } else {
          _controller.isLoading.value = true;
          _controller.currentPage += 1;
          _controller.getData();
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCommonWidget().build("payment_history_app_bar",  (){
        Get.delete<RechargeHistoryController>();
        Modular.to.pop();
      },
      //     action: InkWell(
      //   onTap: (){
      //     _controller.currentPage.value = 1;
      //     showModalBottomSheet<void>(
      //       enableDrag: true,
      //       context: context,
      //       backgroundColor: Colors.black12.withOpacity(0.0),
      //       builder: (BuildContext context) {
      //         return _buildFilter();
      //       },
      //     );
      //   },
      //   child: Container(
      //     child: Image.asset(Assets.filterIcon),
      //   ),
      // )
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildFilter(){
    return Container(
      height: 450.h,
      width: double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Center(child: Text("payment_history_filter_title".tr, style: TextUtils.textStyle(FontWeight.w600, 20.sp, color: AppColors.grayCustom1),),),
            SizedBox(
              height: 20.h,
            ),
            FilterStatusWidget(),
            SizedBox(
              height: 10.h,
            ),
            FilterTimeWidget(),
            SizedBox(
              height: 10.h,
            ),
            FilterNetworkWidget(),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshInfo() async {
    _controller.isLoading.value = true;
    _controller.resetAllController();
    await _controller.getData();

  }

  Widget _buildBody(BuildContext context){
    double _height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _refreshInfo,
          child: Column(
            children: [
              Container(
                  color: Colors.white,
                  child: FilterStatusWidget()),
              SizedBox(
                height: 10.h,
              ),
              Container(
              color: Colors.white,
              height: _height - 166.h,
                child: Obx(() => ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  shrinkWrap: false,
                  scrollDirection: Axis.vertical,
                  itemCount: _controller.listData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _createListItem(
                        context, index);
                  },
                ))),
            ],
          ),
        ),
        Obx(() =>
            Visibility(
              visible: _controller.isLoading.value,
              child: Container(
                  margin: EdgeInsets.only(top: 50.h),
                  child: CustomProgressIndicatorWidget()),
            ),),
        Obx(() =>
            Visibility(
              visible: _controller.isNoNetwork.value,
              child: NetworkUtil.NoNetworkWidget(
                  asyncCallback: ()=>  _controller.getData())
            ),),
      ],
    );
  }

  Widget _createListItem(BuildContext context, int index) {
    return InkWell(
      onTap: (){
        Modular.to.pushNamed(ViewerRoutes.payment_recharge_history_detail, arguments: {'dto': _controller.listData[index]});
      },
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 27.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.symmetric(vertical: 20.h),
                child: Text("payment_history_recharge".tr, style: TextUtils.textStyle(FontWeight.w500, 16.sp, color: AppColors.pink2)),
              ),
              _createItem("payment_history_time".tr, ConvertCommon().convertDate(_controller.listData[index].createdDate!)),
              SizedBox(height: 10.h,),
              _createItem("payment_history_asset".tr, _controller.listData[index].tokenType!, colors: AppColors.grayCustom1, fontWeight: FontWeight.w600),
              SizedBox(height: 10.h,),
              _createItem("".tr, _controller.listData[index].networkName! + "( ${_controller.listData[index].networkType!})", isNetworkType: true),
              SizedBox(height: 10.h,),
              _createItem("payment_history_value".tr, _controller.listData[index].amountToken.toString(), colors: AppColors.grayCustom1, fontWeight: FontWeight.w600),
              SizedBox(height: 10.h,),
              _createItem("".tr, _controller.listData[index].amount.toString(), colors: AppColors.grayCustom1, fontWeight: FontWeight.w600),
              SizedBox(height: 10.h,),
              _createItem("payment_history_status".tr, _controller.listData[index].status!),
              SizedBox(height: 15.h,),
              Divider(
                height: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createItem(String title, String content, {Color? colors, FontWeight? fontWeight, bool isNetworkType = false}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextUtils.textStyle(FontWeight.w600, 13.sp, color: AppColors.grayCustom1),),
        title == '' ? Row(
          children: [
            isNetworkType ? Text(content, style: TextUtils.textStyle(FontWeight.w500, 13.sp, color: AppColors.suvaGrey)) :Text(content, style: TextUtils.textStyle(FontWeight.w500, 13.sp, color: AppColors.suvaGrey),),
            isNetworkType ?
            Container()
                :Container(
                width: 15.w,
                height: 15.h,
                child: Image.asset(Assets.diamondIcon)),
          ],
        ) : Row(
          children: [
            title == 'payment_history_to'.tr ? Padding(
              padding: EdgeInsets.only(right: 15.w),
              child: Icon(Icons.arrow_forward_sharp, size: 20.sp, color: AppColors.mountainMeadow3,),
            ) : Container(),
             title == 'payment_history_status'.tr ? Row(
               children: [
                 ConvertCommon().convertWidgetStatus(content),
                 SizedBox(width: 5.w,),
                 Text(ConvertCommon().convertStatus(content), style: TextUtils.textStyle(FontWeight.w600, 12.sp, color:  ConvertCommon().convertStatusColors(content)),),
               ],
             ) : Text(content, style: TextUtils.textStyle(fontWeight != null ? fontWeight : FontWeight.w400, 13.sp, color: colors != null ? colors : AppColors.grayCustom2),),
          ],
        )
      ],
    );
  }
}

