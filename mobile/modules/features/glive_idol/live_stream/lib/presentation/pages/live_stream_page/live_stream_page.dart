import 'dart:async';
import 'dart:convert';

import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:live_stream/constants/assets.dart' as liveModuleAssets;
import 'package:live_stream/dto/message_dto.dart';
import 'package:live_stream/controllers/camera_live_controller.dart';
import 'package:live_stream/controllers/live_stream_controller.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/chat_button.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/micro_button.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/end_live_button.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/idol_info.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/level_up_widget.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/message_input.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/message_list.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/ruby_count.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/show_message_gift.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/show_notifications.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/view_count.dart';
import 'package:live_stream/services/services.dart';
import 'package:rtmp_publisher/camera.dart';
import 'package:user_management/constants/assets.dart';
import 'package:user_management/domain/entity/response/profile_response.dart';
import 'package:get/get.dart';
import 'package:user_management/presentation/controller/image/image_controller.dart';
import 'package:user_management/presentation/controller/user/user_store_controller.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:live_stream/constants/assets.dart' as asset;

import 'widgets/gift_history_widget.dart';

// ignore: must_be_immutable
class LiveStreamPage extends StatefulWidget {
  final ProfileResponse profile;
  final LiveStreamController liveController;
  final CameraController cameraController;

  LiveStreamPage(
      {Key? key,
      required this.profile,
      required this.liveController,
      required this.cameraController,})
      : super(key: key);

  _LiveStreamPageState createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage>
    with WidgetsBindingObserver {
  final CameraLiveController cameraLiveController =
      Get.put(CameraLiveController());
  final LiveStreamController liveController = Get.put(LiveStreamController());
  ImageController imageController = Get.put(ImageController());
  UserStoreController userStoreController = Get.put(UserStoreController());
  
  late Future<void> _initializeControllerFuture;
  List<String> tagSelect = [];
  TextEditingController _messageController = TextEditingController();
  LiveStreamService _liveApi = Modular.get<LiveStreamService>();
  late Timer _timer;
  late Timer _timerConnectivity;
  late final String storageUrl;
  final List<LiveMessageDto> data = [];
  final String levelUpContains = "LEVEL UP";
  var isMute = false.obs;

  // shared pref object
  late SharedPreferenceHelper _sharedPrefsHelper;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _initializeControllerFuture = Future.wait([
      _initSharedPrefs(),
    ]);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleLevelUpNotify(message);
    });
    _timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      await this._liveApi.heartBeat(widget.liveController.liveId.value)
        ..fold((l) => heartBeatFailed(l), (r) {
          widget.liveController.isServerError.value = false;
        });
    });

    SocketClient.getInstance().on(SocketEvents.IDOL_NOTIFICATION, handleIdolLevelUp);
  }

  handleIdolLevelUp(payload) {
    final message = SocketMessage.fromMap(payload);
    if (message.data != null) {
      switch (message.type) {
        case FirebaseConstants.IDOL_LEVEL_UP:
          widget.liveController.isLevelUp.value = true;
          userStoreController.levelIdol.value = int.parse(message.data!['levelName']);
          widget.liveController.levelUpValue.value = message.body;
          widget.liveController.giftReward.value = storageUrl +  message.data!['level']["armorial"];
          imageController.armorial.value = storageUrl + message.data!['level']["armorial"];
          break;
        case FirebaseConstants.IDOL_RECEIVE_EXP_FROM_LIVE_TIME_PER_DAY:
          widget.liveController.isLiveTime.value = true;
          widget.liveController.titleExp.value = message.title;
          widget.liveController.contentExp.value = message.body;
          break;
      }
    }
  }

  Future<void> _initSharedPrefs() async {
    _sharedPrefsHelper = await SharedPreferenceHelper.getInstance();
    storageUrl = _sharedPrefsHelper.storageServer +
        '/' +
        _sharedPrefsHelper.bucketName +
        '/';
    _timerConnectivity = Timer.periodic(Duration(seconds: 5), (Timer t) async {
      await NetworkUtil.checkConnectivity();
    });
    await Wakelock.enable();
  }

  _handleLevelUpNotify(RemoteMessage message) {
    Map<String, dynamic> data = jsonDecode(message.data[FirebaseConstants.DETAIL]);
    switch (data[FirebaseConstants.TYPE]) {
      case FirebaseConstants.IDOL_LEVEL_UP:
        widget.liveController.isLevelUp.value = true;
        String level = data['level']['key'].toString();
        userStoreController.levelIdol.value = int.parse(level.substring(level.length-1, level.length));
        widget.liveController.levelUpValue.value = message.notification!.body??'';
        widget.liveController.giftReward.value = storageUrl +
            data['level']
                [FirebaseConstants.ARMORIAL];
        imageController.armorial.value = storageUrl +
            data['level']
            [FirebaseConstants.ARMORIAL];
        break;
      case FirebaseConstants.IDOL_RECEIVE_EXP_FROM_LIVE_TIME_PER_DAY:
        widget.liveController.isLiveTime.value = true;
        widget.liveController.titleExp.value = data[FirebaseConstants.TITLE];
        widget.liveController.contentExp.value =
            data[FirebaseConstants.BODY];
        break;
    }
  }

  heartBeatFailed(Failure failure) {
    bool isServerDie = false;
    String errorMessage = '';
    if (failure is DioFailure) {
      if (failure.messageCode == MessageCode.LIVE_SESSION_NOT_ALIVE) {
        errorMessage = 'live_session_not_alive'.tr;
      } else if (failure.messageCode == MessageCode.LIVE_SESSION_NOT_FOUND) {
        errorMessage = 'live_session_not_found'.tr;
      } else if (failure.messageCode == MessageCode.LIVE_SERVER_NOT_ALIVE) {
        widget.liveController.isServerError.value = true;
        isServerDie = true;
      }else {
        errorMessage = 'live_error_disconnect'.tr;
      }
    }
    _timerConnectivity.cancel();
    if(!isServerDie){
      _timer.cancel();
      cameraLiveController.stopVideoStreaming(widget.cameraController, context);
      _showErrorMessage(
        errorMessage.isNotEmpty ? errorMessage : 'live_error_disconnect'.tr,
        errorMessage.isNotEmpty ? '' : 'live_reconnect'.tr,
        barrierDismiss: false,
        customFunction: () => _navigateToLivePreview(),
      );
    }
  }

  @override
  dispose() {
    _timer.cancel();
    _timerConnectivity.cancel();
    liveController.cancelTimer();
    Wakelock.disable();
    WidgetsBinding.instance!.removeObserver(this);
    widget.cameraController.dispose();
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        widget.liveController.showChatInput.value = false;
      },
      child: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Stack(
                children: <Widget>[
                  _buildChatMessages(),
                  Obx(() => Visibility(
                      visible: widget.liveController.isLevelUp.value,
                      child: LevelUpWidget())),
                  Obx(() => Visibility(
                    visible: !widget.liveController.showChatInput.value,
                    child: _bottomButtons(),
                  )),
                  Obx(
                    () => Visibility(
                      visible: widget.liveController.showChatInput.value,
                      child: MessageInput(
                        textController: _messageController,
                        focusNode: widget.liveController.chatTextFocusNode,
                        onSend: () {
                          sendMessage(_messageController.text);
                          _messageController.clear();
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: MediaQuery.of(context).size.height * 0.5,
                    child: ShowMessageGiftWidget(
                      storageUrl: storageUrl,
                      liveController: widget.liveController,
                    ),
                  ),
                  _roomInfoBar(),
                  Obx(()=> Visibility(
                      visible:  widget.liveController.isServerError.value,
                      child: NetworkUtil.ServerErrorWidget(asset: asset.Assets.server_error, asyncCallback: () async {
                        final either = await _liveApi.endLiveSession(
                            widget.liveController.liveId.value,
                            cameraLiveController.streamId.value);
                        either.fold(
                                (failure) =>
                                _endLiveFailed(failure, widget.liveController),
                                (res) => _endLiveSuccess(res, widget.liveController));
                      }))),
                ],
              ),
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildChatMessages() {
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(bottom: 80.h),
          child: MessageList(
            data: data,
            profile: widget.profile,
            storageUrl: storageUrl,
          ),
        ));
  }

  Widget _roomInfoBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 48.h, right: 16.w, left: 0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IdolInfo(
                      avatar: widget.profile.imageUrl??'',
                      profile: widget.profile,
                      storageUrl: storageUrl,
                      sharedPrefsHelper: _sharedPrefsHelper,
                    ),
                    EndLiveButton(
                      onConfirm: () async {
                        _timer.cancel();
                        liveController.cancelTimer();
                        await Wakelock.disable();
                        cameraLiveController.stopVideoStreaming(
                            widget.cameraController, context);
                        final either = await _liveApi.endLiveSession(
                            widget.liveController.liveId.value,
                            cameraLiveController.streamId.value);
                        either.fold(
                            (failure) =>
                                _endLiveFailed(failure, widget.liveController),
                            (res) => _endLiveSuccess(res, widget.liveController));
                      },
                      cameraLiveController: cameraLiveController,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.h, right: 16.w, left: 16.w),
                child: Container(
                  height: 25.h,
                  child: RubyCount(
                    profile: widget.profile,
                    liveController: widget.liveController,
                  ),
                ),
              ),
              Obx(() => Visibility(
                    visible: liveController.isShowIconGift.value,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 0.h, right: 16.w, left: 16.w),
                        child: GiftHistoryWidget(
                          storageUrl: storageUrl,
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                height: 5.h,
              ),
              Obx(
                () => Visibility(
                  visible: widget.liveController.isLiveTime.value,
                  child: ShowNotificationWidget(
                    liveController: widget.liveController,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
                width: 60.w,
                margin: EdgeInsets.only(top: 65.h, right: 70.w),
                child: ViewCount(profile: widget.profile,)),
          ),
        ],
      ),
    );
  }

  Widget _bottomButtons() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ChatButton(
            onPressed: () {
              widget.liveController.showChatInput.value = true;
            },
          ),
          SizedBox(width: 16.w,),
          Container(
            margin: EdgeInsets.only(bottom: 32.h),
            width: 50.h,
            height: 50.h,
            child: InkWell(
              onTap: () {

              },
              child: Image.asset(liveModuleAssets.Assets.gift),
            )
          ),
          SizedBox(width: 16.w,),
          MicroButton(
              isMute: isMute.value,
              onPressed: () async {
                if (isMute.value) {
                  await widget.cameraController.unmute();
                  isMute.value = false;
                } else {
                  await widget.cameraController.mute();
                  isMute.value = true;
                }
              }
          ),
        ],
      ),
    );
  }

  _endLiveSuccess(GatewayResponse res, LiveStreamController liveController) {
    liveController.resetLiveController();
    Modular.to.pushReplacementNamed(IdolRoutes.live_stream.liveEndPage, arguments: {
      'profile': widget.profile,
      'avatar': storageUrl + widget.profile.imageUrl.toString(),
      'fan': res.data['fan'],
      'ruby': res.data['ruby'],
      'liveTime': res.data['liveTime'],
      'viewCount': res.data['viewCount'],
    });
  }

  _endLiveFailed(Failure failure, LiveStreamController liveController) {
    liveController.resetLiveController();
    _showErrorMessage('live_error_unknown'.tr, '', customFunction: () {
      Modular.to.pushReplacementNamed(IdolRoutes.user_management.home);
    });
  }

  void sendMessage(String message) async {
    if (message.trim().isNotEmpty) {
      var data =
          MessageDto(content: message.trim(), roomId: widget.profile.uuid);
      final either = await this._liveApi.sendMessage(data);
      either.fold((l) => {Fluttertoast.showToast(msg: 'live_error_unknown'.tr)},
          (r) => null);
    }
  }

  _showErrorMessage(String title, String subTitle,
      {bool barrierDismiss = true, Function? customFunction}) {
    if (title.isNotEmpty) {
      showDialog(
          context: context,
          barrierDismissible: barrierDismiss,
          builder: (BuildContext context) {
            return new CustomDialogBox(
                buttonText: 'button_close'.tr,
                title: title,
                subTitle: subTitle,
                onPressed: () {
                  Navigator.of(context).pop();
                  if (customFunction != null) {
                    customFunction();
                  }
                },
                imgIcon: AppIconWidget(
                  image: Assets.closeIcon,
                  size: 155.sp,
                  height: 150.h,
                ));
          });
    }
  }

  _navigateToLivePreview() {
    Modular.to.pushReplacementNamed(IdolRoutes.user_management.home);
  } // Modular.to.canPop()

}
