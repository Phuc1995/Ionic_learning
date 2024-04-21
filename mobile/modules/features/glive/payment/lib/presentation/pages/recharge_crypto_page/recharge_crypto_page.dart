import 'dart:async';
import 'package:common_module/common_module.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment/contants/assets.dart';
import 'package:payment/controllers/recharge_crypto_controller.dart';
import 'package:payment/presentation/pages/recharge_crypto_page/widgets/recharge_manual_widget.dart';
import 'package:payment/presentation/pages/recharge_crypto_page/widgets/recharge_wallet_widget.dart';

class RechargeCryptoPage extends StatefulWidget {
  RechargeCryptoPage({Key? key}) : super(key: key);

  _RechargeCryptoPageState createState() => _RechargeCryptoPageState();
}

class _RechargeCryptoPageState extends State<RechargeCryptoPage>  with TickerProviderStateMixin {
  final RechargeCryptoController _rechargeController  = Get.put(RechargeCryptoController());
  late SharedPreferenceHelper _sharedPrefsHelper = Modular.get<SharedPreferenceHelper>();
  late Future<void> _initializeControllerFuture;
  late TabController _tabController;
  GlobalKey buttonKey = GlobalKey();
  late StreamSubscription<RemoteMessage> listenFirebaseMessaging;

  @override
  void initState() {

    WidgetsFlutterBinding.ensureInitialized();
    _tabController = TabController(initialIndex: 0, vsync: this, length: 2,);
    _tabController.addListener(() {
      _rechargeController.currentType.value = _tabController.index;
    });
    _rechargeController.isNoNetwork.value = false;
    _initializeControllerFuture = Future.wait([getNetwork()]);

    super.initState();
  }

  Future<void> getNetwork() async {

    _rechargeController.loading.value = true;
    _rechargeController.getNetworks();
  }

  @override
  void dispose() {
    Get.delete<RechargeCryptoController>();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          brightness: Brightness.light,
          title: Container(
            child: Text("payment_crypto_title".tr,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24.sp,
              ),),
          ),
          leading: IconButton(
              iconSize: 24.sp,
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Modular.to.pop();
              }
          ),
          actions: [
            InkWell(
              onTap: (){
                Modular.to.pushNamed(ViewerRoutes.payment_recharge_history);
              },
              child: Container(
                child: Image.asset(Assets.historyIcon),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.whiteSmoke2,
        body: DeviceUtils.buildWidget(context, _buildBody(context)),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 45.w),
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,
                  indicatorWeight: 3.h,
                  indicatorColor: AppColors.pink1,
                  labelColor: AppColors.pink2,
                  unselectedLabelColor: AppColors.suvaGrey,
                  labelStyle: TextUtils.textStyle(FontWeight.w500, 14.sp),
                  onTap: (value){
                    _rechargeController.currentType.value = value;
                  },
                  tabs: [
                    Tab(child: Text("payment_crypto_tabview_wallet".tr,),),
                    Tab(child: Text("payment_crypto_tabview_manual".tr,)),
                  ],
                ),
              ),
              SizedBox(height: 10.h,),
              Container(
               height: MediaQuery.of(context).size.height * 0.9,
               child: TabBarView(
                 controller: _tabController,
                 children: [
                   RechargeWalletWidget(),
                   RechargeManualWidget(),
                 ],
               ),
             ),
            ],
          ),
        ),
        Obx(() => Visibility(
          visible: _rechargeController.loading.value,
          child: CustomProgressIndicatorWidget(),
        )),
      ],
    );
    //   Stack(
    //   children: [
    //     Obx(
    //       () => Visibility(
    //         visible: !_topUpController.success.value && !_topUpController.isNoNetwork.value,
    //         child: _buildMainContent(),
    //       ),
    //     ),
    //     Obx(
    //       () => Visibility(
    //         visible: _topUpController.success.value,
    //         child: Container(
    //           alignment: Alignment.center,
    //           color: Colors.white,
    //           padding: EdgeInsets.all(18.h),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             crossAxisAlignment: CrossAxisAlignment.stretch,
    //             children: [
    //               Icon(Icons.check_circle_outline, color: Colors.green, size: 200.sp,),
    //               Text('Yều cầu nạp tiền thành công',
    //                 style: TextStyle(
    //                   fontSize: 28.sp
    //                 ),
    //               ),
    //               SizedBox(height: 16.h,),
    //               Text('Vui lòng xác nhận giao dịch trên Momo',
    //                 style: TextStyle(
    //                     fontSize: 24.sp,
    //                     fontWeight: FontWeight.bold,
    //                 ),),
    //               SizedBox(height: 32.h,),
    //               RoundedButtonGradientWidget(
    //                 buttonText: 'Đã xác nhận'.tr,
    //                 buttonColor: AppColors.pinkGradientButton,
    //                 textColor: Colors.white,
    //                 width: double.infinity,
    //                 height: 65.h,
    //                 onPressed: () => Modular.to.pop(),
    //                 textSize: 22.sp,
    //               ),
    //               SizedBox(height: 48.h,),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //     Obx(() => Visibility(
    //       visible: _topUpController.loading.value,
    //       child: CustomProgressIndicatorWidget(),
    //     )),
    //     Obx(() => Visibility(
    //       visible: _topUpController.isNoNetwork.value,
    //       child: NetworkUtil.NoNetworkWidget(asyncCallback: () => checkNetwork()),
    //     )),
    //   ],
    // );
  }
}
