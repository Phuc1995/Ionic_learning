import 'dart:ui';
import 'package:common_module/common_module.dart';
import 'package:common_module/utils/device/device_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:live_stream/constants/assets.dart';
import 'package:live_stream/presentation/pages/live_end_information/widgets/count_time_widget.dart';
import 'package:live_stream/presentation/pages/live_end_information/widgets/glive_info_widget.dart';
import 'package:live_stream/presentation/pages/live_end_information/widgets/idol_info_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/dto/dto.dart';

class LiveEndInformationPage extends StatefulWidget {
  final ViewerLiveRoomDto roomData;
  final Function onDragStar;
  final Function onDragUpdate;
  final Function onDragEnd;

  _LiveEndInformationPageState createState() => _LiveEndInformationPageState();

  LiveEndInformationPage({
    Key? key,
    required this.roomData,
    required this.onDragStar,
    required this.onDragEnd,
    required this.onDragUpdate,
  }) : super(key: key);
}

class _LiveEndInformationPageState extends State<LiveEndInformationPage> {
  late Future<void> _initializeControllerFuture;
  SharedPreferenceHelper _sharedPrefsHelper =
      Modular.get<SharedPreferenceHelper>();
  var urlArmorial = ''.obs;
  String storageUrl = Modular.get<SharedPreferenceHelper>().storageServer +
      '/' +
      Modular.get<SharedPreferenceHelper>().bucketName +
      '/';
  late ImageProvider avatar;

  @override
  initState() {
    super.initState();
    _initializeControllerFuture = Future.wait([
      _initSharedPrefs(),
    ]);
  }

  Future<void> _initSharedPrefs() async {
    // urlArmorial.value = _sharedPrefsHelper.armorial!;
  }

  @override
  dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    try {
      avatar = NetworkImage(storageUrl + widget.roomData.imageUrl.toString());
    } catch (e) {
      avatar = AssetImage(Assets.defaultRoomAvatar);
    }
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: avatar,
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(
                Colors.black26.withOpacity(0.4), BlendMode.darken),
          ),
        ),
        child: new BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: new Container(
            decoration: new BoxDecoration(
              color: Colors.black.withOpacity(0.6),
            ),
            child: GestureDetector(
              onVerticalDragStart: _onDragStar,
              onVerticalDragUpdate: _onDragUpdate,
              onVerticalDragEnd: _onDragEnd,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                    child: DeviceUtils.buildWidget(context, _buildBody())),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          _buildMainContent(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  color: Colors.white,
                  icon: new Icon(Icons.close),
                  iconSize: 32.sp,
                  onPressed: () async {
                    Modular.to.pop();
                  },
                ),
              ),
            ),
            Text(
              "live_end_message".tr,
              style: TextUtils.textStyle(FontWeight.w600, 30.sp,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              height: 180.h,
              width: 180.w,
              child: SizedBox(
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    Center(
                      child: Container(
                          height: 125.h,
                          width: 125.w,
                          child: CircleAvatar(backgroundImage: avatar)),
                    ),
                    Container(
                        alignment: Alignment.center,
                        child: Obx(
                          () => Container(
                            child: urlArmorial.value.isEmpty
                                ? Container()
                                : Image.network(urlArmorial.value),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            IdolInfoWidget(
              gliveId: widget.roomData.name,
              nickName: widget.roomData.gId.toString(),
            ),
            SizedBox(
              height: 30.h,
            ),
            CountTimeWidget(),
            SizedBox(
              height: 10.h,
            ),
            GliveInfoWidget(),
          ],
        ),
    );
  }

  _onDragStar(DragStartDetails details) {
    widget.onDragStar(details);
  }

  _onDragUpdate(DragUpdateDetails details) {
    widget.onDragUpdate(details);
  }

  _onDragEnd(DragEndDetails details) async {
    widget.onDragEnd(details);
  }
}
