import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:payment/contants/assets.dart';
import 'package:payment/contants/contants.dart';
import 'package:payment/controllers/recharge_crypto_controller.dart';
import 'package:payment/dto/dto.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment/service/top_up_service.dart';
import 'package:payment/ultil/recharge_convert.dart';
import 'package:url_launcher/url_launcher.dart';

class RechargeInformationPage extends StatefulWidget {
  final RechargeInformationDto rechargeInformation;
  const RechargeInformationPage({Key? key, required this.rechargeInformation}) : super(key: key);

  @override
  State<RechargeInformationPage> createState() => _RechargeInformationPageState();
}

class _RechargeInformationPageState extends State<RechargeInformationPage> with WidgetsBindingObserver {
  final RechargeCryptoController _rechargeController  = Get.put(RechargeCryptoController());
  final _topUpService = Modular.get<TopUpService>();
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _rechargeController.information.value = widget.rechargeInformation;
    });
    SocketClient.getInstance().on(SocketEvents.VIEWER_TRANSACTION_DEPOSIT_VIA_CRYPTO_SUCCESS, onRechargeSuccess);
    SocketClient.getInstance().on(SocketEvents.VIEWER_TRANSACTION_DEPOSIT_VIA_CRYPTO_FAILED, onRechargeFailed);
    SocketClient.getInstance().on(SocketEvents.VIEWER_TRANSACTION_DEPOSIT_VIA_CRYPTO_FAILED_BY_MINIMUM_AMOUNT, onRechargeFailed);
    SocketClient.getInstance().on(SocketEvents.VIEWER_TRANSACTION_DEPOSIT_VIA_CRYPTO_WAITING, onRechargeWaiting);
    SocketClient.getInstance().on(SocketEvents.VIEWER_TRANSACTION_DEPOSIT_VIA_CRYPTO_DEL, onRechargeDel);
    super.initState();
  }

  void onRechargeSuccess(message) {
    RechargeInformationDto information = RechargeInformationDto.fromMap(message['data']);
    _handleSocketRecharge(message['data'], status: StatusType.COMPLETED.name, information: information);
  }

  void onRechargeFailed(message) {
    RechargeInformationDto information = RechargeInformationDto.fromMap(message['data']);
    if(message['content'].toString().isNotEmpty){
      information.messageErr = message['content'];
    }
    _handleSocketRecharge(message['data'], status: StatusType.FAILED.name, information: information);
  }

  void onRechargeWaiting(message) {
    RechargeInformationDto information = RechargeInformationDto.fromSocketWaitingMap(message['data']);
    _handleSocketRecharge(message['data'], status: StatusType.MANUAL_WAITING_RECHARGE.name, information: information);
  }

 onRechargeDel(message) {
   if (_rechargeController.information.value.status == StatusType.PROCESSING.name ||
       _rechargeController.information.value.status == StatusType.MANUAL_WAITING_RECHARGE.name ||
       _rechargeController.information.value.status == StatusType.NEW.name) {
     _handleRouter(true);
   } else {
     _handleRouterLive();
   }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // _sharedPrefsHelper.getRechargeInformation.then((value) {
      //   _rechargeController.information.value = value!;
      //   _rechargeController.information.refresh();
      // });
    }
  }

  _handleSocketRecharge(dynamic decode, {required String status, required RechargeInformationDto information}){
    try {
      _rechargeController.information.value = information;
      _rechargeController.information.refresh();
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    SocketClient.getInstance().off(SocketEvents.VIEWER_TRANSACTION_DEPOSIT_VIA_CRYPTO_SUCCESS, onRechargeSuccess);
    SocketClient.getInstance().off(SocketEvents.VIEWER_TRANSACTION_DEPOSIT_VIA_CRYPTO_FAILED, onRechargeFailed);
    SocketClient.getInstance().off(SocketEvents.VIEWER_TRANSACTION_DEPOSIT_VIA_CRYPTO_FAILED_BY_MINIMUM_AMOUNT, onRechargeFailed);
    SocketClient.getInstance().off(SocketEvents.VIEWER_TRANSACTION_DEPOSIT_VIA_CRYPTO_DEL, onRechargeDel);
    SocketClient.getInstance().off(SocketEvents.VIEWER_TRANSACTION_DEPOSIT_VIA_CRYPTO_WAITING, onRechargeWaiting);
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _handleRouter(false);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteSmoke2,
        appBar: AppBarCommonWidget().build('payment_crypto_info_app_bar'.tr, (){
          _handleRouter(false);
        }),
        body: DeviceUtils.buildWidget(context, _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10.h),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                    Obx(()=> _rechargeController.information.value.status == null ? Container() : Visibility(
                      visible: _rechargeController.information.value.status?.toUpperCase() == StatusType.PROCESSING.name || _rechargeController.information.value.status?.toUpperCase() == StatusType.NEW.name || _rechargeController.information.value.status?.toUpperCase() == StatusType.MANUAL_WAITING_RECHARGE.name,
                      child: Column(
                        children: [
                          SizedBox(height: 20.h,),
                          _createItem(title: 'payment_crypto_info_token_type'.tr, content:  _rechargeController.information.value.tokenSymbol ?? "" , textStyle: TextUtils.textStyle(FontWeight.w600, 14.sp, color: AppColors.grayCustom1)),
                          _createItem(title: ''.tr, content: "${_rechargeController.information.value.networkName ?? ""} (${_rechargeController.information.value.tokenType ?? ""}) ", textStyle: TextUtils.textStyle(FontWeight.w500, 13.sp, color: AppColors.grey3)),
                          SizedBox(height: 15.h,),
                          _createItemCopy(context, 'payment_crypto_info_address_to'.tr, _rechargeController.information.value.addressTo ?? "", decor: TextDecoration.none),
                           SizedBox(height: 15.h,),
                          _createItem(isStatus: true ,title: 'payment_crypto_info_status'.tr, content: ConvertCommon().convertRechargeCache(_rechargeController.information.value.status!), textStyle: TextUtils.textStyle(FontWeight.w600, 12.sp, color: ConvertCommon().convertStatusColors(_rechargeController.information.value.status!))),
                          SizedBox(height: 15.h,),
                          _rechargeController.information.value.ttl == null ? Container() : _timeItem(title: 'payment_crypto_info_time_expected'.tr, textStyle: TextUtils.textStyle(FontWeight.w600, 14.sp, color: AppColors.mountainMeadow3)),
                          SizedBox(height: 15.h,),
                          _createItem(isNote: true, title: 'payment_crypto_info_note'.tr, content: _rechargeController.currentType.value == 1 ? 'payment_crypto_info_note_content_manual'.tr : 'payment_crypto_info_note_content_wallet'.tr, textStyle: TextUtils.textStyle(FontWeight.w400, 13.sp, color: AppColors.grey6)),
                          SizedBox(height: 30.h,),
                        ],
                      ),
                    ),),

                  //is Completed
                  Obx(()=> _rechargeController.information.value.status == null ? Container() : Visibility(
                    visible: _isFailStatus(_rechargeController.information.value.status!),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h,),
                        _createItem(title: 'payment_crypto_info_time'.tr, content:_rechargeController.information.value.createdDate == null ? "" : ConvertCommon().convertDate(_rechargeController.information.value.createdDate!), textStyle: TextUtils.textStyle(FontWeight.w400, 14.sp, color: AppColors.grayCustom1)),
                        SizedBox(height: 15.h,),
                        _createItem(title: 'payment_crypto_info_token_type'.tr, content: _rechargeController.information.value.tokenSymbol == null ? "" : _rechargeController.information.value.tokenSymbol! , textStyle: TextUtils.textStyle(FontWeight.w600, 14.sp, color: AppColors.grayCustom1)),
                        _createItem(title: ''.tr, content: "${_rechargeController.information.value.networkName ?? ""} (${_rechargeController.information.value.tokenType ?? ""}) " , textStyle: TextUtils.textStyle(FontWeight.w500, 13.sp, color: AppColors.grey3)),
                        SizedBox(height: 15.h,),
                        _createItemCopy(context, 'payment_crypto_info_address_from'.tr, _rechargeController.information.value.addressFrom ?? "", decor: TextDecoration.none),
                        SizedBox(height: 15.h,),
                        _createItemCopy(context, 'payment_crypto_info_address_to'.tr, _rechargeController.information.value.addressTo ?? "", decor: TextDecoration.none),
                        SizedBox(height: 15.h,),
                        _createItemCopy(context, 'payment_crypto_info_txID'.tr, _rechargeController.information.value.txID ?? "", decor: TextDecoration.none),
                        SizedBox(height: 15.h,),
                        _createItem(title: 'payment_crypto_info_amount'.tr, content: _rechargeController.information.value.amountToken == null ? "" : _rechargeController.information.value.amountToken!, textStyle: TextUtils.textStyle(FontWeight.w600, 14.sp, color: AppColors.grayCustom1)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                          _createItem(title: ''.tr, content: _rechargeController.information.value.amount ?? "", textStyle: TextUtils.textStyle(FontWeight.w500, 13.sp, color: AppColors.suvaGrey)),
                            Container(
                                width: 15.w,
                                height: 15.h,
                                child: Image.asset(Assets.diamondIcon)),
                          ],),
                        SizedBox(height: 15.h,),
                        _createItem(isStatus: true ,title: 'payment_crypto_info_status'.tr, content: RechargeConvert().convertTitleStatus(_rechargeController.information.value.status ?? ""), textStyle: TextUtils.textStyle(FontWeight.w600, 12.sp, color: _rechargeController.information.value.status == PaymentContants.COMPLETED ? AppColors.mountainMeadow3 : AppColors.mahogany)),
                        SizedBox(height: 10.h,),
                        Visibility(
                            visible: _rechargeController.information.value.messageErr.isNotEmpty,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(_rechargeController.information.value.messageErr, style: TextUtils.textStyle(FontWeight.w400, 13.sp, color: AppColors.mahogany3)),
                            )),
                        SizedBox(height: 20.h,),
                      ],
                    ),
                  ),),

                ],
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 15.h),
          color: AppColors.whiteSmoke2,
          child: Padding(
            padding: EdgeInsets.only(top: 0.h, left: 17.w, right: 17.w),
            child: RoundedButtonGradientWidget(
              buttonText: 'payment_crypto_info_history_button'.tr,
              buttonColor: AppColors.pinkGradientButton,
              textColor: Colors.white,
              width: double.infinity,
              height: 50.h,
              onPressed: () async {
                Modular.to.pushNamed(ViewerRoutes.payment_recharge_history);
              },
              textSize: 16.sp,
            ),
          ),
        ),
        Obx(() => _rechargeController.information.value.status == null ? Container() :Container(
          padding: EdgeInsets.only(top: 20.h),
          color: AppColors.whiteSmoke2,
          child: Padding(
            padding: EdgeInsets.only(top: 0.h, left: 17.w, right: 17.w),
            child: RoundedButtonGradientWidget(
              buttonText: RechargeConvert().convertRechargeInfoCancelButton(_rechargeController.information.value.status!),
              buttonColor: AppColors.darkGradientBackground2,
              textColor: AppColors.grayCustom1,
              border: Border.all(color: AppColors.whiteSmoke4),
              width: double.infinity,
              height: 50.h,
              onPressed: () async {
                var topUpCache = await _topUpService.deleteTopUpCache();
                topUpCache.fold((l) => null, (data) {
                  if(data.messageCode == PaymentContants.TOP_UP_CACHE_DELETE_MESSAGE_CODE){
                  }
                });
              },
              textSize: 16.sp,
            ),
          ),
        )),
        SizedBox(height: 20.h,),
        InkWell(
          onTap: (){
            Modular.to.pushNamed(ViewerRoutes.payment_recharge_crypto_support);
          },
          child: Center(
            child: Text("payment_crypto_support_question".tr, style: TextUtils.textStyle(FontWeight.w400, 14.sp, color: AppColors.pinkLiveButtonCustom)),
          ),
        ),
      ],
    );
  }

  bool _isFailStatus(String status){
    return status.toUpperCase() == StatusType.FAILED.name || status.toUpperCase() == StatusType.COMPLETED.name;
  }

  void _handleRouter(bool isCancelButton){
    var historyRouter = Modular.to.navigateHistory;
    int indexCryptoPage = historyRouter.indexWhere((element) {
      return element.name == ViewerRoutes.payment_crypto;
    });
    if(isCancelButton){
      if(indexCryptoPage < 0){
        Modular.to.pop();
      } else {
        Modular.to.pushReplacementNamed(ViewerRoutes.payment_crypto);
      }
    } else {
      if(indexCryptoPage < 0){
        Modular.to.pop();
      } else {
        Modular.to.pop();
        Modular.to.pop();
      }
    }
  }

  void _handleRouterLive(){
    var historyRouter = Modular.to.navigateHistory;
    int indexLivePage = historyRouter.indexWhere((element) {
      return element.name == ViewerRoutes.live_channel_idol;
    });
    if(indexLivePage > 0){
      Modular.to.pop();
      Modular.to.pop();
    } else {
      Modular.to.navigate(ViewerRoutes.home,  arguments: {'currentPage' : 0});
    }
  }

  Widget _timeItem({required String title, required TextStyle textStyle}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextUtils.textStyle(FontWeight.w600, 14.sp, color: AppColors.grayCustom1), textAlign: TextAlign.left,),
        Container(
          child: CountdownTimer(
          endTime: DateTime.now().millisecondsSinceEpoch + 1000 * _rechargeController.information.value.ttl!,
          textStyle: TextUtils.textStyle(FontWeight.w600, 16.sp, color: AppColors.wildWatermelon3),
          onEnd: (){
            var history = Modular.to.navigateHistory;
            if(history.last.name == ViewerRoutes.payment_information){
              Modular.to.pushReplacementNamed(ViewerRoutes.payment_crypto);
            }
          },
            ),
        ),
      ],
    );
  }

  Widget _createItem({required String title, required String content, required TextStyle textStyle, bool isStatus = false, bool isNote = false}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextUtils.textStyle(FontWeight.w600, 14.sp, color: AppColors.grayCustom1), textAlign: TextAlign.left,),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isStatus && (_rechargeController.information.value.status == StatusType.PROCESSING.name || _rechargeController.information.value.status == StatusType.MANUAL_WAITING_RECHARGE.name)  ? Align(
              alignment: Alignment.centerRight,
              child: Container(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(backgroundColor: Colors.white, color: AppColors.sunglow2, )),
            ) : Container(),
            isStatus && _rechargeController.information.value.status == PaymentContants.COMPLETED  ? Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 20,
                height: 20,
                child: CircleAvatar(
                  backgroundColor: AppColors.mountainMeadow3,
                    child: Icon(Icons.check, color: Colors.white, size: 14.sp,)),
              ),
            ) : Container(),
            isStatus && _rechargeController.information.value.status == PaymentContants.FAILED  ? Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 20,
                height: 20,
                child: CircleAvatar(
                    backgroundColor: AppColors.mahogany,
                    child: Icon(Icons.cancel, color: Colors.white, size: 14.sp,)),
              ),
            ): Container(),
            SizedBox(width: 5.w,),
            isNote ? Container (
              width: 220.w,
              child: Text(content, textAlign: TextAlign.right, style: textStyle, ),
            ) : Container (
              child: Text(content, textAlign: TextAlign.right, style: textStyle, ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _createItemCopy(BuildContext context, String title, String content, {TextDecoration? decor}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextUtils.textStyle(FontWeight.w600, 14.sp, color: AppColors.grayCustom1), textAlign: TextAlign.left,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InkWell(
              onTap: () async {
                String url = "";
                if(title == "payment_crypto_info_txID".tr){
                  url = _rechargeController.information.value.explorerUrl! + _rechargeController.information.value.txPath! +  _rechargeController.information.value.txID!;
                } else {
                  url = _rechargeController.information.value.explorerUrl! +  _rechargeController.information.value.accountPath! +  content;
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
                child: Text(content.isEmpty ? "" : TextUtils.maskAddress(content, start: 17, end: content.length - 8), textAlign: TextAlign.right, style: TextUtils.textStyle(FontWeight.w400, 12.sp, color: AppColors.grayCustom1, decor: decor!),),
              ),
            ),
            SizedBox(width: 5.w,),
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
