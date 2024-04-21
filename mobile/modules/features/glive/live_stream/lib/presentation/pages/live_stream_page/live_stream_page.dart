import 'dart:async';
import 'package:common_module/common_module.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:live_stream/domain/entity/message_dto.dart';
import 'package:live_stream/domain/entity/show_notification_in_app_entity.dart';
import 'package:live_stream/domain/service/live_stream_service.dart';
import 'package:live_stream/presentation/controller/live/live_controller.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/chat_button.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/gift_button.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/idol_info.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/level_up_widget.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/ruby_count.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/show_message_gift.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/show_notifications.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/show_notificatoon_live.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/view_count.dart';
import 'package:live_stream/repository/live_api_repository.dart';
import 'package:get/get.dart';
import 'package:user_management/controllers/follow_controller.dart';
import 'package:user_management/dto/dto.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wakelock/wakelock.dart';
import 'widgets/manage_gift/show_gift.dart';
import 'widgets/message_input.dart';
import 'widgets/message_list.dart';

class LiveStreamPage extends StatefulWidget {
  final LiveController liveController;
  final ViewerLiveRoomDto roomData;
  final StreamController<bool> stream;
  final FijkPlayer fijkPlayer;

  LiveStreamPage(
      {Key? key, required this.liveController, required this.roomData, required this.stream, required this.fijkPlayer})
      : super(key: key);

  _LiveStreamPageState createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> with WidgetsBindingObserver, AutomaticKeepAliveClientMixin<LiveStreamPage> {
  FollowController _followController = Get.put(FollowController());
  late Future<void> _initializeControllerFuture;
  List<String> tagSelect = [];
  late Timer _timer;
  late Timer _timerHeartBeat;
  TextEditingController _messageController = TextEditingController();
  String storageUrl = Modular.get<SharedPreferenceHelper>().storageServer + '/' +Modular.get<SharedPreferenceHelper>().bucketName + '/';
  LiveApiRepository _liveApi = Modular.get<LiveApiRepository>();
  LiveStreamService _liveService = Modular.get<LiveStreamService>();
  LiveController _liveController = Get.put(LiveController());
  bool  isNotifySettingLive = true;
  String userUuid = Modular.get<SharedPreferenceHelper>().getUserUuid;

  @override
  initState() {
    super.initState();
    widget.liveController.isMoveNotifyLive.value = false;
    widget.liveController.showChatInput.value = false;
    WidgetsBinding.instance!.addObserver(this);
    _initializeControllerFuture = Future.wait([
      _initSharedPrefs(),
    ]);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleLevelUpNotify(message);
    });

    _timerHeartBeat = Timer.periodic(Duration(seconds: 10), (timer) async {
      await this._liveService.heartBeat(widget.liveController.currentRoom.value.id);
    });

    SocketClient.getInstance().on(SocketEvents.VIEWER_NOTIFICATION, handleNotification);

  }

  handleNotification(payload) {
    final message = SocketMessage.fromMap(payload);
    if (message.data != null) {
      switch (message.type) {
        case FirebaseConstants.VIEWER_LEVEL_UP:
          widget.liveController.isLevelUp.value = true;
          widget.liveController.levelUpValue.value = message.body;
          widget.liveController.giftReward.value = storageUrl + payload['data']['level'][FirebaseConstants.ARMORIAL];
          break;
        case FirebaseConstants.IDOL_LIVESTREAM:
          ShowNotificationInAppEntity notify = ShowNotificationInAppEntity.fromMap(payload);
          int index = _liveController.listNotify.indexWhere((ele) => ele.uuidIdol == notify.uuidIdol);
          if (!message.silent) {
            var historyRouter = Modular.to.navigateHistory;
            int indexLivePage = historyRouter.indexWhere((element) {
              return element.name == ViewerRoutes.live_channel_idol;
            });
            if(notify.isBell && isNotifySettingLive && indexLivePage >= 0 && index < 0){
              _liveController.listNotify.insert(0, notify);
              _showNotify();
            }
          }
          break;
        case FirebaseConstants.VIEWER_RECEIVE_EXP_FROM_TIME_VIEW_LIVESTREAM_PER_DAY:
          widget.liveController.isLiveTime.value = true;
          widget.liveController.titleExp.value = message.title;
          widget.liveController.contentExp.value = message.body;
          break;
      }
    }
  }

  void _showNotify() async {
    if(!_liveController.isNotifyShowing){
      _liveController.isMoveNotifyLive.value = true;
      _liveController.isNotifyShowing = true;
      if(_liveController.listNotify.length > 0) {
        _liveController.notificationInAppEntity.value = _liveController.listNotify[_liveController.listNotify.length - 1];
        _liveController.notificationInAppEntity.refresh();
        await Future.delayed(Duration(seconds: 3), (){
          _liveController.isMoveNotifyLive.value = false;
        });
        await Future.delayed(Duration(seconds: 1), (){
          _liveController.isNotifyShowing = false;
          _liveController.listNotify.removeAt(_liveController.listNotify.length - 1);
          _showNotify();
        }
        );
      } else {
        _liveController.isMoveNotifyLive.value = false;
        _liveController.isNotifyShowing = false;
      }
    }
  }

  Future<void> _initSharedPrefs() async {
    _followController.getIdolDetail(widget.roomData.id);
    _liveController.joinRoom();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) async {
      await NetworkUtil.checkConnectivity();
    });
    await Wakelock.enable();
  }

  _handleLevelUpNotify(RemoteMessage message) {}

  @override
  dispose() {
    _timer.cancel();
    _timerHeartBeat.cancel();
    Wakelock.disable();
    WidgetsBinding.instance?.removeObserver(this);
    if (_liveController.isShownGiftBox.value) {
      Modular.to.pop();
    }
    SocketClient.getInstance().off(SocketEvents.VIEWER_NOTIFICATION, handleNotification);
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
      child: Center(
        child: Stack(
          children: <Widget>[
            _roomInfoBar(),
            _buildChatMessages(),
            Obx(() => Visibility(
                visible: widget.liveController.isLevelUp.value,
                child: LevelUpWidget(storageUrl: storageUrl,))),
            Obx(
              () => Visibility(
                visible: !widget.liveController.showChatInput.value,
                child: _bottomButtons(),
              ),
            ),
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
                // storageUrl: widget.storageUrl,
                liveController: widget.liveController,
              ),
            ),
            Obx(() => AnimatedPositioned(
              onEnd: (){
              },
              right: _liveController.isMoveNotifyLive.value  ? -2.w : -400.w,
              top: MediaQuery.of(context).size.height * 0.15,
              duration: Duration(milliseconds: 1000),
              curve: Curves.easeOut,
              child: ShowNotificationLive(stream: widget.stream, fijkPlayer: widget.fijkPlayer),
            )),
          ],
        ),
      ),
    );
  }

  Widget _bottomButtons() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ChatButton(
            onPressed: () {
              widget.liveController.showChatInput.value = true;
            },
          ),
          GiftButton(
            onPressed: () {
              _liveController.isShownGiftBox.value = true;
              showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                barrierColor: Colors.transparent,
                context: context,
                backgroundColor: Colors.black.withOpacity(0.6),
                builder: (BuildContext context) {
                  return Container(
                    color: Colors.black87,
                    child: ShowGift(
                      roomData: widget.roomData,
                      storageUrl: storageUrl,
                    ),
                  );
                },
              ).whenComplete(() {
                _liveController.isShownGiftBox.value = false;
              });
            },
          ),
        ],
      ),
    );
  }

  void sendMessage(String message) async {
    if (message.trim().isNotEmpty) {
      await this
          ._liveApi
          .sendMessage(MessageDto(roomId: widget.roomData.id, content: message))
        ..fold((l) => banChatHandle(l), (r) => null);
    }
  }

  banChatHandle(l) {
    _liveController.dataMessage
        .insert(0, new LiveMessageDto(id: '-1', type: 'ban', isSystem: true, armorial: '', medal: ''));
  }

  errorHandle(l) {
    Modular.to.pushReplacementNamed(ViewerRoutes.home, arguments: {'currentPage' : 0});
  }

  Widget _roomInfoBar() {
    _liveController.currentRoom.value.viewCount = widget.roomData.viewCount;
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 48.h, right: 16.w, left: 0.w),
                child: IdolInfo(
                  roomData: widget.roomData,
                  roomId: widget.liveController.currentRoom.value.id,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.h, right: 16.w, left: 16.w),
                child: Container(
                  height: 25.h,
                  child: RubyCount(
                    roomId: widget.liveController.currentRoom.value.id,
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Obx(() => Visibility(
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
              margin: EdgeInsets.only(top: 60.h, right: 55.w),
                child: ViewCount(roomId: widget.roomData.id,)),
          ),
        ],
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
              gId: userUuid,
              data: _liveController.dataMessage,
              roomId: widget.roomData.id,
              storageUrl: storageUrl,
            ),
          ),
        );
  }

  @override
  bool get wantKeepAlive => true;
}
