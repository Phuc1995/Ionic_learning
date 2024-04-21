import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:rtmp_publisher/camera.dart';
import 'package:user_management/constants/assets.dart';
import 'package:user_management/domain/entity/response/profile_response.dart';
import 'package:user_management/presentation/page/home_page/tab_model.dart';
import 'package:user_management/domain/usecase/auth/update_device_info.dart';
import 'package:user_management/presentation/controller/user/user_store_controller.dart';
import 'package:user_management/repository/user_info_api_repository.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:user_management/presentation/page/user_info_page/user_info_page.dart';
import 'package:common_module/common_module.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int _selectedIndex = 0;

  var _loading = false.obs;

  final logger = Modular.get<Logger>();
  List<TabModel> tabs = TabModel.homeTabs;
  final UserInfoApiRepository _accountInfoApi = Modular.get<UserInfoApiRepository>();
  UserStoreController userController = Get.put(UserStoreController());
  List<CameraDescription> _cameras = [];
  late Future<void> _initializeControllerFuture;
  late SharedPreferenceHelper _sharedPrefsHelper;
  late StreamSubscription<String> _subFirebaseToken;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    availableCameras().then((values) => _cameras = values);
    _initializeControllerFuture = Future.wait([_fetchProfile(), asyncInit()]);
    SocketClient.getInstance().on(SocketEvents.IDOL_NOTIFICATION, handleNotification);
  }

  handleNotification(payload) {
    final message = SocketMessage.fromMap(payload);
    if (!message.silent) {
      FirebaseMessage.showMessage(message);
    }
    if (message.data != null) {
      switch (message.type){
        case FirebaseConstants.IDOL_VERIFY_ACCOUNT_APPROVED:
        case FirebaseConstants.IDOL_VERIFY_ACCOUNT_PENDING:
          _fetchProfile();
          break;
      }
    }
  }

  Future<void> asyncInit() async {
    _sharedPrefsHelper = await SharedPreferenceHelper.getInstance();
    final deviceInfo = await DeviceUtils.getDeviceId();
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      _sharedPrefsHelper.setFirebaseToken(token);
      await UpdateDeviceInfo().call(DeviceInfoParams(deviceId: deviceInfo.deviceId, deviceModel: deviceInfo.deviceModel, fcmToken: token));
    }
    _subFirebaseToken = FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      final String currentToken = _sharedPrefsHelper.firebaseToken;
      if (currentToken != token) {
        _sharedPrefsHelper.setFirebaseToken(token);
        await UpdateDeviceInfo().call(DeviceInfoParams(deviceId: deviceInfo.deviceId, deviceModel: deviceInfo.deviceModel, fcmToken: token));
      }
    });
  }

  String getGLiveID(String? uuid) {
    final uuidArr = uuid != null ? uuid.toString().split('-') : [''];
    String uuidLast = uuidArr[uuidArr.length - 1];
    return this.userController.profile.value.gId != null ? this.userController.profile.value.gId.toString() : uuidLast.toString();
  }

  Future<void> _fetchProfile() async {
    if (this._loading.value) {
      return;
    }
    this._loading.value = true;
    final either = await _accountInfoApi.fetchProfile();
    either.fold((l) {
      this._loading.value = false;
      ShowShortMessage().show(context: context, message: "error_unknown".tr, backgroundColor: AppColors.pinkLiveButtonCustom);
    }, (res) {
      this._loading.value = false;
      if (res.data != null) {
        this.userController.profile.value = ProfileResponse.fromMap(res.data);
        this.userController.isApproved.value = this.userController.profile.value.identity != null ? this.userController.profile.value.identity!.statusVerify == 'APPROVED' : false;
        userController.balance.value = this.userController.profile.value.balance.toString();
        SocketClient.userUuid = this.userController.profile.value.uuid;
        SocketClient.join();
      } else {
        this.userController.profile.value = new ProfileResponse();
        this.userController.isApproved.value = false;
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      SocketClient.getInstance().on(SocketEvents.IDOL_NOTIFICATION, handleNotification);
    } else {
      SocketClient.getInstance().off(SocketEvents.IDOL_NOTIFICATION, handleNotification);
    }
  }

  @override
  dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _subFirebaseToken.cancel();
    SocketClient.getInstance().off(SocketEvents.IDOL_NOTIFICATION, handleNotification);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return DeviceUtils.buildWidget(context, _buildBody());
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        }
      ),
      bottomNavigationBar: Obx(()=>StyleProvider(
        style: Style(),
        child: ConvexAppBar(
          items: TabModel.homeTabs.map((p) => p.tabItem).toList(),
          initialActiveIndex: _selectedIndex,
          style: TabStyle.fixedCircle,
          backgroundColor: Colors.white,
          color: this.userController.isApproved.value ? AppColors.pinkLiveButtonCustom : AppColors.grey2,
          activeColor: this.userController.isApproved.value ? AppColors.pinkLiveButtonCustom : AppColors.grey2,
          onTabNotify: (int index) {
            if (index == 2) {
              _canLiveStream().then((value) => {
                if (value)
                  {
                    this.userController.profile.value.gId = getGLiveID(this.userController.profile.value.uuid),
                    Modular.to.pushNamed(IdolRoutes.live_stream.livePreviewPage,
                        arguments: {'profile': this.userController.profile.value, 'cameras': _cameras})
                  }
              });
              return false;
            }
            return true;
          },
          onTap: (int index) async {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),)
      ),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        _buildMainContent(),
        Obx(() => Visibility(
          visible: this._loading.value,
          child: CustomProgressIndicatorWidget(),
        )),
      ],
    );
  }

  Widget _buildMainContent() {
    Widget widget = TabModel.homeTabs.elementAt(_selectedIndex).widget;
    if (_selectedIndex == 0) {
      widget = UserInfoPage(profile: this.userController.profile.value, onRefresh: () => _fetchProfile(),);
    }
    return Material(
        child: Center(
          child: widget,
        )
    );
  }

  Future<bool> _canLiveStream() async {
    await this._fetchProfile();
    if (!this.userController.isApproved.value) {
    _showErrorMessage('live_error_verify'.tr, '');
    return Future<bool>.value(false);
    } else if ((this.userController.profile.value.imageUrl == null || this.userController.profile.value.imageUrl == '') &&
        ((this.userController.profile.value.gId == null || this.userController.profile.value.gId == ''))) {
      _showErrorMessage('live_error_avatar_and_gid'.tr, '');
      return Future<bool>.value(false);
    } else if (this.userController.profile.value.imageUrl == null || this.userController.profile.value.imageUrl == '') {
      _showErrorMessage('live_error_avatar'.tr, '');
      return Future<bool>.value(false);
    } else if (this.userController.profile.value.gId == null || this.userController.profile.value.gId == '') {
      _showErrorMessage('live_error_gid'.tr, '');
      return Future<bool>.value(false);
    } else if (_cameras.length == 0) {
      _showErrorMessage('live_error_no_camera'.tr, '');
      return Future<bool>.value(false);
    }
    return Future<bool>.value(true);
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String title, String subTitle) {
    if (title.isNotEmpty) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new CustomDialogBox(
              buttonText: 'button_close'.tr,
              title: title,
              subTitle: subTitle,
              onPressed: () => Navigator.of(context).pop(),
              imgIcon: AppIconWidget(
                image: Assets.closeIcon,
                size: 155.sp,
                height: 150.h,
              )
            );
          });
    }
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
