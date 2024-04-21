import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:user_management/domain/entity/response/profile_response.dart';
import 'package:user_management/domain/usecase/notification/count_unread_notification.dart';
import 'package:user_management/presentation/controller/notification/notification_controller.dart';
import 'package:user_management/presentation/controller/user/user_store_controller.dart';
import 'package:user_management/presentation/page/user_info_page/widget/nickname_item.dart';
import 'package:user_management/presentation/page/user_info_page/widget/notify_button_widget.dart';
import 'package:user_management/presentation/controller/image/image_controller.dart';
import 'package:user_management/presentation/page/user_info_page/widget/active_status.dart';
import 'package:user_management/presentation/page/user_info_page/widget/blance_item.dart';
import 'package:user_management/presentation/page/user_info_page/widget/count_item.dart';
import 'package:user_management/presentation/page/user_info_page/widget/menu_list.dart';
import 'package:user_management/presentation/widgets/avatar_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/services/experience_service.dart';

// ignore: must_be_immutable
class UserInfoPage extends StatefulWidget {
  ProfileResponse profile;
  Function onRefresh;

  UserInfoPage({
    Key? key,
    required this.profile,
    required this.onRefresh,

  }) : super(key: key);

  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  ScrollController _scrollController = ScrollController();
  late final String storageUrl;
  double _patternHeight = 200.h;
  double _patternRadius = 80.r;
  var loading = false.obs;

  ImageController imageController = Get.put(ImageController());
  NotificationController notificationController = Get.put(NotificationController());
  UserStoreController userStoreController = Get.put(UserStoreController());

  final logger = Modular.get<Logger>();

  late Future<void> _initializeControllerFuture;

  // shared pref object
  late SharedPreferenceHelper _sharedPrefsHelper;

  String getGLiveID(String? uuid) {
    final uuidArr = uuid != null ? uuid.toString().split('-') : [''];
    String uuidLast = uuidArr[uuidArr.length - 1];
    return widget.profile.gId != null ? widget.profile.gId.toString() : uuidLast.toString();
  }

  Future<void> _refreshInfo() async {
        loading.value = true;
        try {
          await Future.wait([
            _initDataIdolExperience(),
            _getNotification(),
          ]);
          widget.onRefresh();
          loading.value  = false;
        } finally {
          loading.value  = false;
        }
  }

  Future _getNotification() async {
    final res = await CountUnreadNotification().call(NoParams());
    res.fold((l) => null, (number) => notificationController.unreadNotification.value = number);
  }

  @override
  initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _initializeControllerFuture = Future.wait([
      asyncInit(),
      _refreshInfo(),
    ]);
  }

  Future<void> asyncInit() async {
    _sharedPrefsHelper = await SharedPreferenceHelper.getInstance();
    storageUrl = _sharedPrefsHelper.storageServer + '/' + _sharedPrefsHelper.bucketName + '/';
  }

  Future<void> _initDataIdolExperience() async {
    final experienceService = Modular.get<ExperienceService>();
    final data = await experienceService.getExperience();
    data.fold((failure) {
      if(failure is DioFailure){
        if(failure.messageCode == "ACCOUNT_IS_BANNED"){
          userStoreController.isBan.value = true;
          userStoreController.isSuccess.value = false;
          userStoreController.logout();
        }}
    }, (data) {
      userStoreController.levelIdol.value = int.parse(data.level.substring(data.level.length - 1));
      imageController.armorial.value = storageUrl + data.armorial;
      _sharedPrefsHelper.setArmorial(storageUrl + data.armorial);
    });
  }

  @override
  dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    double appBarHeight = MediaQuery.of(context).padding.top + kToolbarHeight;
    double appBarPosition = 40.h;
    if (_scrollController.offset >= appBarPosition) {
      setState(() {
        _patternHeight = appBarHeight;
        _patternRadius = 0;
      });
    } else {
      setState(() {
        _patternHeight = 200.h;
        _patternRadius = 80.r;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      child: Stack(
        children: <Widget>[
          _buildAppbar(),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                widget.profile.fullName == null ? widget.profile.username: widget.profile.fullName!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              automaticallyImplyLeading: false,
              actions: _buildActions(context),
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            body: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return _buildBody();
                  } else {
                    // Otherwise, display a loading indicator.
                    return Center();
                  }
                }),
          ),
          Obx(() =>
              Visibility(
                visible: loading.value,
                child: CustomProgressIndicatorWidget(),
              ),)

        ],
      ),
    );
  }

  Widget _buildAppbar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        height: _patternHeight,
        duration: Duration(seconds: 1),
        curve: Curves.fastLinearToSlowEaseIn,
        decoration: new BoxDecoration(
          gradient: AppColors.pinkGradientButton,
          borderRadius: new BorderRadius.only(
            bottomLeft: Radius.circular(_patternRadius),
            bottomRight: Radius.circular(_patternRadius),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      // ScanButton(),
      // FriendButton(),
      NotifyButtonWidget(),
    ];
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _refreshInfo,
      child: Stack(
        children: <Widget>[
          ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [ SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  color: Colors.transparent,
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Container(
                          child: AvatarWidget(
                            fileUrl: widget.profile.imageUrl ?? '',
                            imageController: imageController,
                            sharedPrefsHelper: _sharedPrefsHelper,
                            onChange: (String val) {
                              setState(() {
                                widget.profile.imageUrl = val;
                                widget.onRefresh();
                              });
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(margin: EdgeInsets.only(top: 180.h), child: _buildInfo()),
                      ),
                    ],
                  ),
                ),
              )]
          )
        ],
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.h),
          child: Column(
            children: <Widget>[
              NicknameItem(
                statusVerify: widget.profile.identity == null ? null : widget.profile.identity!.statusVerify,
                nickname: widget.profile.gId,
                onPressed: () {
                  Modular.to.pushNamed(IdolRoutes.user_management.accountEditNickName, arguments: {
                    'profile_to_edit': widget.profile,
                  }).then((value) => setState(() {
                        widget.onRefresh();
                      }));
                },
              ),
              Obx(() => Visibility(
                visible: userStoreController.profile.value.identity == null || !userStoreController.isApproved.value,
                child: ActiveStatus(
                    status:
                    widget.profile.identity != null ? widget.profile.identity!.statusVerify : null,
                    note: widget.profile.identity != null ? widget.profile.identity!.note : null),
              )),
              SizedBox(height: 10.h,),
              Obx(
                () => _buildCount(
                  level: userStoreController.levelIdol.value,
                  follow: widget.profile.counter != null ? widget.profile.totalFollow : 0,
                  fan: widget.profile.counter != null ? widget.profile.counter!.fans : 0,
                  moment: widget.profile.counter != null ? widget.profile.counter!.moments : 0,
                ),
              ),
              BalanceItem(),
              // MyFeatures(),
            ],
          ),
        ),
        MenuList(
          profile: widget.profile,
          onPressed: (menu) {
            Modular.to.pushNamed(menu, arguments: {
              'profile': widget.profile,
            }).then((value) => setState(() {
                  widget.onRefresh();
                }));
          },
        ),
      ],
    );
  }

  Widget _buildCount({
    int level = 0,
    int follow = 0,
    int fan = 0,
    int moment = 0,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CountItem(
            count: level,
            text: 'Level',
            onTap: () async {
                  Modular.to.pushNamed(IdolRoutes.level.levelDetailPage);
            }
          ),
          // CountItem(count: follow, text: 'home_follows'.tr, onTap: () {}),
          CountItem(count: follow, text: 'home_fans'.tr, onTap: () {}),
          // CountItem(count: moment, text: 'Moments', onTap: () {}),
        ],
      ),
    );
  }
}
