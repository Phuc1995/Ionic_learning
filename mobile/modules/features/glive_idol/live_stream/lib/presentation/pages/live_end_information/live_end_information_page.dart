import 'dart:ui';
import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:live_stream/presentation/pages/live_end_information/widgets/glive_info.dart';
import 'package:live_stream/presentation/pages/live_end_information/widgets/idol_info.dart';
import 'package:user_management/domain/entity/response/profile_response.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/presentation/controller/image/image_controller.dart';
import 'package:user_management/presentation/controller/user/user_store_controller.dart';
import 'package:user_management/repository/user_info_api_repository.dart';

class LiveEndInformationPage extends StatefulWidget {
  final ProfileResponse profile;
  final String avatar;
  final num? viewCount;
  final num? fan;
  final num? ruby;
  final num? liveTime;

  _LiveEndInformationPageState createState() => _LiveEndInformationPageState();

  LiveEndInformationPage({
    Key? key,
    required this.fan,
    required this.ruby,
    required this.viewCount,
    required this.liveTime,
    required this.avatar,
    required this.profile,
  }) : super(key: key);
}

class _LiveEndInformationPageState extends State<LiveEndInformationPage> {
  late SharedPreferenceHelper _sharedPrefsHelper;
  var urlArmorial = ''.obs;
  ImageController imageController = Get.put(ImageController());
  @override
  initState() {
    super.initState();
    Future.wait([
      _initSharedPrefs(),
    ]);
  }

  Future<void> _initSharedPrefs() async {
    _sharedPrefsHelper = await SharedPreferenceHelper.getInstance();
    urlArmorial.value = _sharedPrefsHelper.armorial!;
  }

  @override
  dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.avatar),
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(Colors.black26.withOpacity(0.4), BlendMode.darken),
          ),
        ),
        child: new BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: new Container(
            decoration: new BoxDecoration(
              color: Colors.black.withOpacity(0.2),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              body: SafeArea(child: DeviceUtils.buildWidget(context, _buildBody())),
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
    ProfileResponse _profile = new ProfileResponse();
    UserStoreController userStoreController = Get.put(UserStoreController());
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
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
                          child: CircleAvatar(backgroundImage: NetworkImage(widget.avatar))),
                    ),
                    Container(
                        alignment: Alignment.center,
                        child: Obx(
                          () => Container(
                            child: Image.network(imageController.armorial.value),
                          ),
                        )),
                    Positioned(
                      top: 0,
                      right: 0,
                      height: 50.h,
                      width: 50.w,
                      child: IconButton(
                        color: Colors.white,
                        icon: new Icon(Icons.close),
                        iconSize: 32.sp,
                        onPressed: () async {
                          final UserInfoApiRepository _accountInfoApi = Modular.get<UserInfoApiRepository>();
                          _accountInfoApi.fetchProfile().then((res) {
                            res.fold((l) => null, (data) {
                              _profile = ProfileResponse.fromMap(data.data);
                              userStoreController.balance.value = _profile.balance ?? '0';
                            });
                          });
                          Modular.to.navigate(IdolRoutes.user_management.home);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IdolInfoWidget(
              gliveId: widget.profile.fullName.toString(),
              nickName: widget.profile.gId.toString(),
            ),
            SizedBox(
              height: 80.h,
            ),
            Center(
              child: Container(
                width: 320.w,
                height: 268.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color:  Colors.white24,
                ),
                child: GliveInfoWidget(
                  gliveId: widget.profile.fullName.toString(),
                  nickName: widget.profile.gId.toString(),
                  fan: widget.fan,
                  liveTime: widget.liveTime,
                  ruby: widget.ruby,
                  viewCount: widget.viewCount,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
