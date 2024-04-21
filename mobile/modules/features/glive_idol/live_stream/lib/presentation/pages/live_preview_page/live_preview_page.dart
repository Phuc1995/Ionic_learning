import 'dart:async';

import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:live_stream/controllers/live_stream_controller.dart';
import 'package:live_stream/presentation/pages/live_preview_page/widgets/room_info_bar.dart';
import 'package:live_stream/presentation/pages/live_preview_page/widgets/room_info_row.dart';
import 'package:live_stream/presentation/pages/live_preview_page/widgets/start_live_button.dart';
import 'package:live_stream/presentation/pages/live_preview_page/widgets/tag_bottom_sheet.dart';
import 'package:live_stream/controllers/camera_live_controller.dart';
import 'package:live_stream/presentation/pages/live_stream_page/live_stream_page.dart';
import 'package:live_stream/presentation/widgets/camera_preview_widget.dart';
import 'package:live_stream/services/live_stream_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:user_management/constants/assets.dart';
import 'package:user_management/domain/entity/request/live-session.dart';
import 'package:user_management/domain/entity/response/profile_response.dart';
import 'package:user_management/presentation/dialogs/show_error_message.dart';
import 'package:wakelock/wakelock.dart';
import 'package:rtmp_publisher/camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_stream/constants/assets.dart' as asset;
// ignore: must_be_immutable
class LivePreviewPage extends StatefulWidget {
  ProfileResponse profile;
  List<CameraDescription> cameras = [];

  LivePreviewPage({
    Key? key,
    required this.profile,
    required this.cameras,
  }) : super(key: key);

  _LivePreviewPageState createState() => _LivePreviewPageState();
}

class _LivePreviewPageState extends State<LivePreviewPage> with WidgetsBindingObserver {
  CameraLiveController cameraLiveController = Get.put(CameraLiveController());
  LiveStreamController liveController = Get.put(LiveStreamController());
  TextEditingController _roomNameController = TextEditingController();
  late CameraController _cameraController;
  LiveStreamService _liveApi = Modular.get<LiveStreamService>();

  String fullRoomName = '';
  String? urlRTMP;
  List<String> tagSelect = [];
  var _isLoading = false.obs;
  bool enableAudio = true;
  bool useOpenGL = true;

  // shared pref object
  late SharedPreferenceHelper _sharedPrefsHelper;
  late String storageUrl;
  late Future<void> _initializeControllerFuture;
  Map<Permission, PermissionStatus> _statuses = {};

  @override
  initState() {
    super.initState();
    cameraLiveController.isLive.value = false;
    liveController.isServerError.value = false;
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance!.addObserver(this);
    _initializeControllerFuture = Future.wait([_initSharedPrefs(), _initCamera()]);
  }

  Future<void> _initCamera() async {
    // To display the current output from the Camera,
    // create a CameraController.
    await _requestPermission();
    cameraLiveController.description.value = widget.cameras
        .firstWhere((description) => description.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(
      cameraLiveController.description.value,
      ResolutionPreset.high,
      streamingPreset: ResolutionPreset.high,
      enableAudio: enableAudio,
      androidUseOpenGL: useOpenGL,
    );
    try {
      await _cameraController.initialize();
    } catch (err) {
      print(err);
      ShowErrorMessage().show(context: context, message: "live_error_camera".tr);
    }
  }

  Future<void> _initSharedPrefs() async {
    _sharedPrefsHelper = await SharedPreferenceHelper.getInstance();
    storageUrl = _sharedPrefsHelper.storageServer + '/' + _sharedPrefsHelper.bucketName + '/';
  }

  @override
  dispose() {
    cameraLiveController.stopVideoStreaming(_cameraController, context);
    _cameraController.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    Wakelock.disable();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      liveController.chatTextFocusNode.unfocus();
    }
    if (state == AppLifecycleState.resumed) {
      if (liveController.chatTextFocusNode.canRequestFocus) {
        liveController.chatTextFocusNode.requestFocus();
      }
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    await _cameraController.dispose();
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      streamingPreset: ResolutionPreset.high,
      enableAudio: enableAudio,
      androidUseOpenGL: useOpenGL,
    );
    // If the controllers is updated then update the UI.
    _cameraController.addListener(() {
      if (mounted) setState(() {});
      if (_cameraController.value.hasError) {
        ShowErrorMessage().show(context: context, message: "live_error_camera".tr);
      }
    });

    try {
      await _cameraController.initialize();
    } on CameraException catch (e) {
      ShowErrorMessage().show(context: context, message: "live_error_camera".tr);
    }

    if (mounted) {
      setState(() {
        cameraLiveController.description.value = cameraDescription;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.black12,
        resizeToAvoidBottomInset: false,
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (!_hasPermission()) {
                Future.delayed(Duration(milliseconds: 500), () {
                  Navigator.of(context).pop();
                  _showErrorMessage('live_error_permission'.tr, 'live_error_permission_hint'.tr);
                });
                return const Center(child: CircularProgressIndicator());
              }
              return Center(
                child: Stack(
                  children: <Widget>[
                    Visibility(
                      visible: _cameraController.value.isInitialized??false,
                      child: CameraPreviewWidget(
                        cameraController: _cameraController,
                      ),
                    ),
                    Obx(() => Visibility(
                        visible: !cameraLiveController.isLive.value,
                        child: Stack(
                          children: [
                            Container(
                              color: Colors.black26,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                            ),
                            RoomInfoBar(
                                child: _roomInfoRow(_sharedPrefsHelper),
                                onSwitchCamera: () {
                                  cameraLiveController.description.value = CameraLiveController().switchCamera(cameraLiveController.description.value, widget.cameras);
                                  onNewCameraSelected(cameraLiveController.description.value);
                                }
                            ),
                            StartLiveButton(
                              onPressed: () async {
                                await _setUpLive();
                              },
                            ),
                            Obx(() => Visibility(
                              visible: _isLoading.value,
                              child: CustomProgressIndicatorWidget(),
                            ))
                          ],
                        ))),
                    Obx(() => Visibility(
                        visible: cameraLiveController.isLive.value,
                        child: LiveStreamPage(
                          profile: widget.profile,
                          liveController: liveController,
                          cameraController: _cameraController,
                        ))),
                    Obx(()=> Visibility(
                        visible:  liveController.isServerError.value,
                        child: NetworkUtil.ServerErrorWidget(asset: asset.Assets.server_error, asyncCallback: () async {
                          Modular.to.pop();
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
        //
      ),
      onWillPop: () async {
        return false;
      },
    );
  }

  Widget _roomInfoRow(sharedPrefsHelper) {
    return RoomInfoRow(
      sharedPrefsHelper: _sharedPrefsHelper,
      profile: widget.profile,
      storageUrl: storageUrl,
      tags: tagSelect,
      textController: _roomNameController,
      onPressed: () => _showModalBottom(),
      onEditingComplete: () {
        fullRoomName = _roomNameController.text;
        if (_roomNameController.text.length > 22) {
          _roomNameController.text = _roomNameController.text.substring(0, 19) + '...';
        }
      },
    );
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> startVideoStreaming(urlRTMP) async {
    if (!(_cameraController.value.isInitialized??false)) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    if (_cameraController.value.isStreamingVideoRtmp??false) {
      return null;
    }

    try {
      await _cameraController.startVideoStreaming(urlRTMP);
      //remove command to see the log streaming send data to server
      // _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      //   var stats = await _cameraController!.getStreamStatistics();
      //   // print(stats);
      // });
    } on CameraException catch (e) {
      ShowErrorMessage().show(context: context, message: "live_error_camera".tr);
      return null;
    }
  }

  Future<void> _setUpLive() async {
    _isLoading.value = true;
    String roomAvatar = _sharedPrefsHelper.thumbnail != null ? _sharedPrefsHelper.thumbnail.toString() : '';
    _isLoading.value = true;
    final deviceInfo = await DeviceUtils.getDeviceId();
    String deviceId = deviceInfo.deviceId;
    final either = await _liveApi.createLiveSession(LiveSessionDto(
      deviceId: deviceId,
      userUuid: widget.profile.uuid,
      roomAvatar: roomAvatar != '' && roomAvatar != 'null'
          ? roomAvatar
          : widget.profile.imageUrl.toString(),
      roomName: widget.profile.gId ?? widget.profile.username,
      tags: tagSelect.length > 0 ? tagSelect.join('|').tr : '',
    ));
    either.fold((failure) => _setupLiveFailed(failure), (res) => _setupLiveSuccess(res));
  }

  _setupLiveSuccess(GatewayResponse res) {
    _isLoading.value = false;
    if (res.messageCode! == MessageCode.LIVE_SESSION_RESUMED) {
      Fluttertoast.showToast(msg: 'live_session_resumed'.tr);
    }
    liveController.liveId.value = res.data['id'];
    this._liveApi.heartBeat(liveController.liveId.value);
    urlRTMP = res.data['ingest']['url'].toString() + "/"+ res.data['ingest']['key'].toString();
    startVideoStreaming(urlRTMP);
    cameraLiveController.streamId.value = res.data['streamId'];
    cameraLiveController.isLive.value = true;
    liveController.setUpCountTime();
  }

  _setupLiveFailed(Failure failure) {
    _isLoading.value = false;
    String errorMessage = 'live_error_unknown'.tr;
    if (failure is DioFailure) {
      switch(failure.messageCode){
        case MessageCode.LIVE_SESSION_ALIVE_ERROR :
          errorMessage = 'live_session_alive'.tr;
          _showErrorMessage(errorMessage, '');
          break;
        case MessageCode.LIVE_STREAM_CHANNEL_CAN_NOT_CREATE :
          liveController.isServerError.value = true;
          break;
        default:
          _showErrorMessage(errorMessage, '');
      }
    } else {
      _showErrorMessage(errorMessage, '');
    }
  }

  void _showModalBottom() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          List<String> _tagSelect = new List.from(tagSelect);
          return StatefulBuilder(builder: (BuildContext context, StateSetter setStateModal) {
            return TagBottomSheet(
              setStateModal: setStateModal,
              tags: _tagSelect,
              onPressed: () {
                setState(() {
                  tagSelect = _tagSelect;
                });
                Navigator.of(context).pop();
              },
            );
          });
        });
  }

  Future<void> _requestPermission() async {
    try {
      _statuses[Permission.camera] = await Permission.camera.request();
      _statuses[Permission.microphone] = await Permission.microphone.request();
    } catch (ex) {
      _statuses[Permission.camera] = PermissionStatus.denied;
      _statuses[Permission.microphone] = PermissionStatus.denied;
    }
  }

  bool _hasPermission() {
    return (_statuses[Permission.camera] == PermissionStatus.granted ||
            _statuses[Permission.camera] == PermissionStatus.limited) &&
        (_statuses[Permission.microphone] == PermissionStatus.granted ||
            _statuses[Permission.microphone] == PermissionStatus.limited);
  }

  _showErrorMessage(String title, String subTitle) {
    if (title.isNotEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return new CustomDialogBox(
              buttonText: 'button_close'.tr,
              title: title,
              subTitle: subTitle,
              onPressed: () {
                Modular.to.pushReplacementNamed(IdolRoutes.user_management.home);
              },
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


