import 'dart:async';

import 'package:common_module/common_module.dart';
import 'package:common_module/presentation/widget/loaders/color_loader_4.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:live_stream/constants/assets.dart';
import 'package:live_stream/presentation/controller/live/live_controller.dart';
import 'package:live_stream/presentation/pages/live_channel_idol/widgets/fijk_custom_panel.dart';
import 'package:live_stream/presentation/pages/live_end_information/live_end_information_page.dart';
import 'package:live_stream/presentation/pages/live_stream_page/live_stream_page.dart';
import 'package:get/get.dart';
import 'package:live_stream/presentation/pages/live_channel_idol/widgets/end_live_button.dart';
import 'package:user_management/dto/dto.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveChannelIdolPage extends StatefulWidget {
  final ViewerLiveRoomDto roomData;

  LiveChannelIdolPage({Key? key, required this.roomData}) : super(key: key);

  _LiveChannelIdolPageState createState() => _LiveChannelIdolPageState();
}

class _LiveChannelIdolPageState extends State<LiveChannelIdolPage>
    with WidgetsBindingObserver {
  LiveController _liveController = Get.put(LiveController());
  String _userUuid =
      Modular.get<SharedPreferenceHelper>().getUserUuid.toString();
  FijkPlayer fijkPlayer = FijkPlayer();
  var playerPrepared = false.obs;
  var playerPlaying = false.obs;

  String storageUrl = Modular.get<SharedPreferenceHelper>().storageServer +
      '/' +
      Modular.get<SharedPreferenceHelper>().bucketName +
      '/';
  String fullRoomName = '';
  String? urlRTMP;
  List<String> tagSelect = [];
  DateTime? timeStart;
  bool enableAudio = true;
  bool useOpenGL = true;
  bool isPress = false;

  //Swipe page
  StreamController<bool> controllerSwipe = StreamController.broadcast();
  double positionStar = 0;
  var isSwipeDow = false.obs;
  static const int sensitivity = 2;
  static const double minHeightPercentage = 0.3;
  double pageHeight = 0;
  var topContainerHeight = 0.0.obs;
  var bottomContainerHeight = 0.0.obs;
  var isShowImg = true.obs;
  var previousImage = "".obs;
  var nextImage = "".obs;
  var isSwiping = false.obs;
  late StreamSubscription _subLiveRoom;

  @override
  initState() {
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance!.addObserver(this);
    _liveController.dataMessage.clear();
    fijkPlayer.addListener(_playerValueChanged);
    subscribeLiveRoom();
    super.initState();
  }

  Future<void> subscribeLiveRoom() async {
    _subLiveRoom = FirebaseStorage.getLiveRoomById(_liveController.currentRoom.value.id).listen((event) async {
      if (event.snapshot.exists) {
        await fijkPlayer.reset();
        if(_liveController.isEndLive.value) _liveController.isEndLive.value = false;
        Map<String, dynamic> snapshotMap = Map<String, dynamic>.from(event.snapshot.value);
        _liveController.currentRoom.value = ViewerLiveRoomDto.fromMap(snapshotMap);
        await fijkPlayer.setDataSource(_liveController.currentRoom.value.flv ?? _liveController.currentRoom.value.hls.toString(), autoPlay: true);
      } else {
        _liveController.isEndLive.value = true;
      }
    });
  }

  @override
  void dispose() async {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    Wakelock.disable();
    await _subLiveRoom.cancel();
    await controllerSwipe.close();
    await fijkPlayer.release();
  }

  void _playerValueChanged() {
    FijkValue value = fijkPlayer.value;
    playerPlaying.value = (value.state == FijkState.started);
    playerPrepared.value = value.prepared;
    if (value.exception.code != FijkException.ok) {
      fijkPlayer.reset();
      print('Player exception ${value.exception.message}');
      fijkPlayer.reset().then((value) {
        Future.delayed(Duration(seconds: 2), () {
          fijkPlayer.setDataSource(_liveController.currentRoom.value.flv ?? _liveController.currentRoom.value.hls.toString(), autoPlay: true);
        });
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _liveController.chatTextFocusNode.unfocus();
    }
    if (state == AppLifecycleState.resumed) {
      if (_liveController.chatTextFocusNode.canRequestFocus) {
        _liveController.chatTextFocusNode.requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    pageHeight = MediaQuery.of(context).size.height;
    _setImageSwipe();
    return WillPopScope(
        onWillPop: () async {
          _liveController.leaveRoom();
          Modular.to.pop();
          return false;
        },
        child: GestureDetector(
          onVerticalDragStart: _onDragStar,
          onVerticalDragUpdate: _onDragUpdate,
          onVerticalDragEnd: _onDragEnd,
          child: Scaffold(
            backgroundColor: Colors.black87,
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                StreamBuilder<bool>(
                    stream: controllerSwipe.stream,
                    builder: (context, snapshot) {
                      return Align(
                        alignment: Alignment.center,
                        child: StreamBuilder<void>(
                          stream: FirebaseStorage.getLiveRoomById(
                              _liveController.currentRoom.value.id),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData &&
                                !snapshot.hasError &&
                                snapshot.data.snapshot.value != null) {
                              return Stack(
                                children: <Widget>[
                                  SizedBox.expand(
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: SizedBox(
                                          width: MediaQuery.of(context)
                                              .size
                                              .longestSide,
                                          height: MediaQuery.of(context)
                                              .size
                                              .longestSide,
                                          child: IgnorePointer(
                                            ignoring: false,
                                            child: _buildPlayer(),
                                          )),
                                    ),
                                  ),
                                  PageView(
                                    onPageChanged: (int) {
                                      DeviceUtils.hideKeyboard(context);
                                    },
                                    scrollDirection: Axis.horizontal,
                                    padEnds: true,
                                    reverse: true,
                                    children: [
                                      LiveStreamPage(
                                        roomData: _liveController.currentRoom.value,
                                        liveController: _liveController,
                                        stream: controllerSwipe,
                                        fijkPlayer: fijkPlayer,
                                      ),
                                      Container()
                                    ],
                                  ),
                                  Positioned(
                                    top: 50.h,
                                    right: 20.w,
                                    child: Container(
                                      width: 40.w,
                                      height: 40.h,
                                      child: EndLiveButton(
                                        onConfirm: () async {
                                          _liveController.leaveRoom();
                                          _liveController.showChatInput.value = false;
                                          Modular.to.pop();
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Stack(
                                children: <Widget>[
                                  LiveEndInformationPage(
                                    roomData: _liveController.currentRoom.value,
                                    onDragEnd: (data) => _onDragEnd(data),
                                    onDragStar: (data) => _onDragStar(data),
                                    onDragUpdate: (data) => _onDragUpdate(data),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      );
                    }),
                Obx(() => _buildSwipePage(
                      alignment: Alignment.topCenter,
                      height: topContainerHeight.value,
                      imgPath: previousImage.value,
                    )),
                Obx(() => _buildSwipePage(
                      alignment: Alignment.bottomCenter,
                      height: bottomContainerHeight.value,
                      imgPath: nextImage.value,
                    )),
              ],
            ),
          ),
        ));
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildPlayer() {
    return Obx(() =>
      !playerPrepared.value || !playerPlaying.value || isSwiping.value
          ? _loadingVideo()
          : FijkView(
            player: fijkPlayer,
            fit: FijkFit(
              sizeFactor: 1.0,
              aspectRatio: -1,
              alignment: Alignment.center,
            ),
            panelBuilder: fijkCustomPanelBuilder,
          ),
    );
  }

  Widget _loadingVideo() {
    return Obx(() => Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundLoadingGradient,
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black26.withOpacity(0.4), BlendMode.srcATop),
            image: NetworkImage(storageUrl +
                _liveController.currentRoom.value.thumbnail.toString()),
            fit: BoxFit.cover,
          ),
        ),
        child: _iconLoading()));
  }

  Widget _iconLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          Assets.logo_loading,
          width: 60.w,
        ),
        SizedBox(
          height: 20.h,
        ),
        ColorLoader4(),
        SizedBox(
          height: 50.h,
        ),
      ],
    );
  }

  Widget _buildSwipePage({
    required AlignmentGeometry alignment,
    required double height,
    required String imgPath,
  }) {
    return Align(
      alignment: alignment,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isShowImg.value ? 1 : 0,
        child: AnimatedContainer(
          curve: Curves.easeOutCirc,
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: height > 0 ? height : 0,
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  AppColors.whiteSmoke9.withOpacity(0.77), BlendMode.srcATop),
              image: imgPath.isNotEmpty ? NetworkImage(storageUrl + imgPath) : Image.asset(Assets.defaultRoomAvatar).image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  _onDragStar(DragStartDetails details) {
    if (isSwiping.value) {
      return;
    }
    positionStar = details.globalPosition.dy;
  }

  _onDragUpdate(DragUpdateDetails details) {
    if (isSwiping.value) {
      return;
    }
    final swipedDistance = details.globalPosition.dy - positionStar;
    positionStar = details.globalPosition.dy;

    if (topContainerHeight.value != 0 || bottomContainerHeight.value != 0) {
      final mappedDistance = swipedDistance * sensitivity;

      if (isSwipeDow.value) {
        topContainerHeight.value += mappedDistance;
      } else {
        bottomContainerHeight.value -= mappedDistance;
      }
      return;
    }

    // Detect swipe dow
    if (swipedDistance > 0) {
      isSwipeDow.value = true;
      topContainerHeight.value = swipedDistance;
      return;
    }

    // Detect swipe up
    if (swipedDistance < 0) {
      isSwipeDow.value = false;
      bottomContainerHeight.value = swipedDistance.abs();
    }
  }

  _onDragEnd(DragEndDetails details) async {
    if (isSwiping.value) {
      return;
    }
    if (topContainerHeight.value >= pageHeight * minHeightPercentage ||
        bottomContainerHeight >= pageHeight * minHeightPercentage) {
      isSwiping.value = true;
      try {
        topContainerHeight.value = isSwipeDow.value ? pageHeight : 0;
        bottomContainerHeight.value = !isSwipeDow.value ? pageHeight : 0;

        await Future.delayed(const Duration(milliseconds: 200), () {
          isShowImg.value = false;
        });

        //Handle update info Idol when swipe page
        if (isSwipeDow.value) {
          _liveController.dataMessage.clear();
          await _liveController.handleSwipeChannel(
              false, _userUuid);
          controllerSwipe.add(false);
        } else {
          _liveController.dataMessage.clear();
          await _liveController.handleSwipeChannel(
              true, _userUuid);
          controllerSwipe.add(true);
        }
        await _subLiveRoom.cancel();
        subscribeLiveRoom();

        await Future.delayed(const Duration(milliseconds: 300), () {
          topContainerHeight.value = 0;
          bottomContainerHeight.value = 0;
        });

        await Future.delayed(const Duration(milliseconds: 300), () {
          isShowImg.value = true;
          _setImageSwipe();
        });

      } catch (e) {
        print(e);
      } finally {
        isSwiping.value = false;
      }
    } else {
      topContainerHeight.value = 0;
      bottomContainerHeight.value = 0;
    }
  }

  _setImageSwipe() {
    if (_liveController.listRoom.length > 0) {
      final previous = _liveController
          .listRoom[_liveController.currentRoomIndex.value <= 0
          ? _liveController.listRoom.length - 1
          : _liveController.currentRoomIndex.value - 1];
      previousImage.value = previous.thumbnail ?? previous.imageUrl ?? '';

      final next = _liveController
          .listRoom[_liveController.currentRoomIndex.value >=
          _liveController.listRoom.length - 1
          ? 0
          : _liveController.currentRoomIndex.value + 1];
      nextImage.value = next.thumbnail ?? next.imageUrl ?? '';
    }
  }
}
