import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/controllers/user_store_controller.dart';
import 'package:user_management/dto/dto.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:user_management/presentation/page/user_info_page/user_info_page.dart';
import 'package:common_module/common_module.dart';

class HomePage extends StatefulWidget {
  final int currentPage;
  const HomePage({Key? key, required this.currentPage}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  UserStoreController _userStoreController = Get.put(UserStoreController());
  late SharedPreferenceHelper _sharedPrefsHelper = Modular.get<SharedPreferenceHelper>();
  late StreamSubscription<String> _subFirebaseToken;
  late StreamSubscription<ReceivedAction> _subNotificationAction;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _selectedIndex = this.widget.currentPage;
    _subNotificationAction = _userStoreController.notificationSubjects();
    SocketClient.getInstance().on(SocketEvents.VIEWER_NOTIFICATION, _userStoreController.handleNotification);
    SocketClient.getInstance().on(SocketEvents.VIEWER_TRANSACTION_DEPOSIT_VIA_CRYPTO_NEW, _userStoreController.onRechargeNew);
    SocketClient.getInstance().on(SocketEvents.VIEWER_TRANSACTION_DEPOSIT_VIA_CRYPTO_WAITING, _userStoreController.onRechargeWaiting);
    SocketClient.getInstance().on(SocketEvents.VIEWER_TRANSACTION_DEPOSIT_VIA_CRYPTO_SUCCESS, _userStoreController.onRechargeSuccess);
    SocketClient.getInstance().on(SocketEvents.VIEWER_TRANSACTION_DEPOSIT_VIA_CRYPTO_FAILED, _userStoreController.onRechargeFailed);
    SocketClient.getInstance().on(SocketEvents.VIEWER_TRANSACTION_DEPOSIT_VIA_CRYPTO_FAILED_BY_MINIMUM_AMOUNT, _userStoreController.onRechargeFailed);
    Future.wait([_userStoreController.fetchProfile(), asyncInit()]);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _subFirebaseToken.cancel();
    _subNotificationAction.cancel();
    SocketClient.getInstance().off(SocketEvents.VIEWER_NOTIFICATION, _userStoreController.handleNotification);
    SocketClient.getInstance().off(SocketEvents.VIEWER_TRANSACTION_DEPOSIT_VIA_CRYPTO_NEW, _userStoreController.onRechargeNew);
    SocketClient.getInstance().off(SocketEvents.VIEWER_TRANSACTION_DEPOSIT_VIA_CRYPTO_WAITING, _userStoreController.onRechargeWaiting);
    SocketClient.getInstance().off(SocketEvents.VIEWER_TRANSACTION_DEPOSIT_VIA_CRYPTO_SUCCESS, _userStoreController.onRechargeSuccess);
    SocketClient.getInstance().off(SocketEvents.VIEWER_TRANSACTION_DEPOSIT_VIA_CRYPTO_FAILED, _userStoreController.onRechargeFailed);
    SocketClient.getInstance().off(SocketEvents.VIEWER_TRANSACTION_DEPOSIT_VIA_CRYPTO_FAILED_BY_MINIMUM_AMOUNT, _userStoreController.onRechargeFailed);
    super.dispose();
  }

  Future<void> asyncInit() async {
    final deviceInfo = await DeviceUtils.getDeviceId();
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      _sharedPrefsHelper.setFirebaseToken(token);
      await _userStoreController.updateDeviceInfo(deviceInfo, token);
    }
    _subFirebaseToken = FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      final String currentToken = _sharedPrefsHelper.firebaseToken;
      if (currentToken != token) {
        _sharedPrefsHelper.setFirebaseToken(token);
        await _userStoreController.updateDeviceInfo(deviceInfo, token);
      }
    });
    // logger.e(token);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      SocketClient.getInstance().on(SocketEvents.VIEWER_NOTIFICATION, _userStoreController.handleNotification);
    } else {
      SocketClient.getInstance().off(SocketEvents.VIEWER_NOTIFICATION, _userStoreController.handleNotification);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DeviceUtils.buildWidget(context, _buildBody()),
      bottomNavigationBar: StyleProvider(
        style: Style(),
        child: ConvexAppBar(
          items: TabModelDto.homeTabs.map((p) => p.tabItem).toList(),
          initialActiveIndex: _selectedIndex,
          style: TabStyle.react,
          top: 0,
          backgroundColor: Colors.white,
          height: 65.h,
          activeColor: _userStoreController.isApproved ? AppColors.pinkLiveButtonCustom : AppColors.grey2,
          onTabNotify: (int index) {
            return true;
          },
          onTap: (int index) async {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        _buildMainContent(),
        // Obx(() => Visibility(
        //   visible: _userStoreController.isLoading.value,
        //   child: CustomProgressIndicatorWidget(),
        // )),
      ],
    );
  }

  Widget _buildMainContent() {
    Widget widget = TabModelDto.homeTabs.elementAt(_selectedIndex).widget;
    if (_selectedIndex == 4) {
      UserInfoPage info = widget as UserInfoPage;
      info.onRefresh = () => _userStoreController.fetchProfile();
    }
    return Material(
        child: Center(
          child: widget,
        )
    );
  }

}

class Style extends StyleHook {
  @override
  double get activeIconSize => 40.sp;

  @override
  double get activeIconMargin => 10.sp;

  @override
  double get iconSize => 20.sp;

  @override
  TextStyle textStyle(Color color) {
    return TextStyle(fontSize: 20.sp, color: color);
  }
}
