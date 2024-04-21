import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:user_management/controllers/user_store_controller.dart';
import 'package:user_management/presentation/page/user_info_page/widget/nickname_item.dart';
import 'package:user_management/presentation/page/user_info_page/widget/notify_button_widget.dart';
import 'package:user_management/presentation/page/user_info_page/widget/blance_item.dart';
import 'package:user_management/presentation/page/user_info_page/widget/count_item.dart';
import 'package:user_management/presentation/page/user_info_page/widget/menu_list.dart';
import 'package:user_management/presentation/widgets/avatar_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserInfoPage extends StatefulWidget {
  Function? onRefresh;

  UserInfoPage({
    Key? key,
    this.onRefresh,
  }) : super(key: key);

  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  ScrollController _scrollController = ScrollController();
  late SharedPreferenceHelper _sharedPrefsHelper = Modular.get<SharedPreferenceHelper>();
  late final String storageUrl = _sharedPrefsHelper.getStorageUrl();
  final logger = Modular.get<Logger>();
  UserStoreController _userStoreController = Get.put(UserStoreController());
  double _patternHeight = 200.h;
  double _patternRadius = 80.r;

  @override
  initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  dispose() {
    _scrollController.removeListener(_scrollListener);
    _userStoreController.refreshInfo(widget.onRefresh);
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
      child: Stack(
        children: <Widget>[
          _buildAppbar(),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                this._userStoreController.profile.value.fullName == null ? this._userStoreController.profile.value.username: this._userStoreController.profile.value.fullName!,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              automaticallyImplyLeading: false,
              actions: _buildActions(context),
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            body: _buildBody(),
          ),
          Obx(() => Visibility(
            visible: _userStoreController.isInfoLoading.value,
            child: CustomProgressIndicatorWidget(),
          ),),
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
      NotifyButtonWidget(),
    ];
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: () async {
        _userStoreController.refreshInfo(widget.onRefresh);
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
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
                  child: Obx(() => AvatarWidget(
                      storageUrl: _userStoreController.storageUrl.value,
                      fileUrl: this._userStoreController.profile.value.imageUrl ?? '',
                      onChange: (String val) {
                        setState(() {
                          this._userStoreController.profile.value.imageUrl = val;
                          if (widget.onRefresh != null) {
                            widget.onRefresh!();
                          }
                        });
                      },
                    ),
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
                uuid: this._userStoreController.profile.value.uuid,
                nickname: this._userStoreController.profile.value.gId,
                onPressed: () {
                  Modular.to.pushNamed(ViewerRoutes.account_edit_nick_name, arguments: {
                    'profile_to_edit': _userStoreController.profile.value,
                  }).then((value) => setState(() {
                        if (widget.onRefresh != null) {
                          widget.onRefresh!();
                        }
                      }));
                },
              ),
              Obx(() => _userStoreController.profile.value.level != null ?
                _buildCount(level: _userStoreController.profile.value.level!.name, follow: _userStoreController.profile.value.idolsFollowed!) :
                Container()
              ),
              SizedBox(height: 10.h,),
              Obx(() => BalanceItem(
                balance: _userStoreController.balance.value,
              )),
              // MyFeatures(),
            ],
          ),
        ),
        MenuList(
          profile: this._userStoreController.profile.value,
          onPressed: (menu) {
            Modular.to.pushNamed(menu, arguments: {
              'profile': this._userStoreController.profile.value,
            }).then((value) => setState(() {
                  if (widget.onRefresh != null) {
                    widget.onRefresh!();
                  }
                }));
          },
        ),
      ],
    );
  }

  Widget _buildCount({
    String level = "1",
    String follow = "0",
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
            onTap: () => Modular.to.pushNamed(ViewerRoutes.level_detail),
          ),
          CountItem(count: follow, text: 'home_follows'.tr, onTap: () {}),
        ],
      ),
    );
  }
}
