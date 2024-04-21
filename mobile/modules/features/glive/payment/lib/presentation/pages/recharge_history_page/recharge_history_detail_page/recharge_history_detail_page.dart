import 'package:common_module/common_module.dart';
import 'package:common_module/presentation/widget/app_bar/app_bar_common.dart';
import 'package:common_module/utils/device/text_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:payment/contants/assets.dart';
import 'package:payment/dto/dto.dart';
import 'package:url_launcher/url_launcher.dart';

class RechargeHistoryDetailPage extends StatelessWidget {
  final TopUpHistoryDto entity;
  const RechargeHistoryDetailPage({Key? key, required this.entity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCommonWidget().build("payment_history_detail_app_bar",  (){
        Modular.to.pop();
      },),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      color: Colors.white,
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
            _createItem("payment_history_time".tr, ConvertCommon().convertDate(entity.createdDate!)),
            SizedBox(height: 10.h,),
            _createItem("payment_history_asset".tr, entity.tokenType!, colors: AppColors.grayCustom1, fontWeight: FontWeight.w600),
            SizedBox(height: 10.h,),
            _createItem("".tr, "${entity.networkName} (${entity.networkType!})", isNetworkType: true),
            SizedBox(height: 10.h,),
            _createItem("payment_history_value".tr, entity.amountToken.toString(), colors: AppColors.grayCustom1, fontWeight: FontWeight.w600),
            SizedBox(height: 10.h,),
            _createItem("".tr, entity.amount.toString(), colors: AppColors.grayCustom1, fontWeight: FontWeight.w600),
            SizedBox(height: 10.h,),
            _createItemTxt(context, "payment_history_from".tr, entity.tokenAddressFrom!, colors: AppColors.summerSky, decor: TextDecoration.underline),
            SizedBox(height: 10.h,),
            _createItemTxt(context, "payment_history_to".tr, entity.tokenAddressTo!, colors: AppColors.summerSky, decor: TextDecoration.underline),
            SizedBox(height: 10.h,),
            _createItemTxt(context, "payment_history_tx_hash".tr, entity.transactionHash!, colors: AppColors.summerSky, decor: TextDecoration.underline),
            SizedBox(height: 10.h,),
            _createItem("payment_history_status".tr, entity.status!),
            SizedBox(height: 10.h,),
            entity.errorMessage == "" ? Container() : _createItemErr("", "payment_history_detail_err_minimum_amount".trParams({'param': '5 ${entity.tokenType}'})),
            SizedBox(height: 15.h,),
            Divider(
              height: 1,
            ),
          ],
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

  Widget _createItemErr(String title, String content){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextUtils.textStyle(FontWeight.w600, 13.sp, color: AppColors.grayCustom1),),
        Text(content, style: TextUtils.textStyle(FontWeight.w500, 13.sp, color: AppColors.mahogany),),]);
  }

  Widget _createItemTxt(BuildContext context, String title, String content, {Color? colors, TextDecoration? decor}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextUtils.textStyle(FontWeight.w600, 13.sp, color: AppColors.grayCustom1),),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
          InkWell(
              onTap: () async {
                String url = "";
                if(title == "payment_history_tx_hash".tr){
                  url = entity.explorerUrl! + entity.txPath! +  entity.transactionHash!;
                } else {
                  url = entity.explorerUrl! + entity.accountPath! +  content;
                }
                print(url);
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Container(
                width: 220.w,
                child: Text(content, textAlign: TextAlign.right, style: TextUtils.textStyle(FontWeight.w400, 12.sp, color: AppColors.grayCustom1, decor: decor!),),
              ),
            ),
            InkWell(
              onTap: (){
                Clipboard.setData(ClipboardData(text: content)).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'home_copied'.tr,
                        style: TextUtils.textStyle(FontWeight.w500, 19.sp,
                            color: Colors.white),
                      )));
                });
              },
              child: Container(
                width: 14.w,
                height: 15.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Assets.copy,)),
                  )
              ),
            )
          ],
        ),

      ],
    );
  }
}
