import 'package:common_module/common_module.dart';
import 'package:common_module/presentation/widget/dialog/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_stream/domain/entity/gift_dto.dart';
import 'package:live_stream/presentation/controller/live/category_controller.dart';
import 'package:user_management/constants/assets.dart';
import 'package:user_management/dto/dto.dart';
import 'package:user_management/presentation/widgets/icon_button_widget.dart';
import 'package:user_management/repositorise/user_info_api_repository.dart';
import 'package:payment/service/top_up_service.dart';

class ShowGift extends StatefulWidget {
  final String storageUrl;
  final ViewerLiveRoomDto roomData;

  const ShowGift({Key? key, required this.storageUrl, required this.roomData})
      : super(key: key);

  @override
  State<ShowGift> createState() => _ShowGiftState();
}

class _ShowGiftState extends State<ShowGift> {
  CategoryController _categoryController = Get.put(CategoryController());
  final _topUpService = Modular.get<TopUpService>();
  int dropdownValue = 10;
  String giftSelectCode = '';
  var giftSelect = null;
  int amount = 1;
  bool showSelectAmount = false;
  final UserInfoApiRepository _accountInfoApi = Modular.get<UserInfoApiRepository>();
  late SharedPreferenceHelper _sharedPrefsHelper = Modular.get<SharedPreferenceHelper>();

  @override
  void initState() {
    super.initState();
    getCategory();
    _refreshInfo();
  }

  Future<void> getCategory() async {
    await this._categoryController.getCategoryGift();
    this._categoryController.setActiveId();
  }

  Future<void> _refreshInfo() async {
    await this.fetchData();
  }

  Future fetchData() async {
    var responses = await Future.wait([
      _accountInfoApi.fetchProfile(),
    ]);
    responses[0].fold((l) => null, (res) {
      if (res.data != null) {
        ProfileResponseDto profile = ProfileResponseDto.fromMap(res.data);
        _categoryController.balance.value = int.parse(profile.balance ?? '0');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => this._categoryController.activeId.value > 0
          ? Container(
              height: 420.h,
              width: 600.w,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 1.h),
                          child: _buildListCategory(),
                        ),
                        SizedBox(
                          height: 240.h,
                          child: this
                                      ._categoryController
                                      .categories[this
                                              ._categoryController
                                              .activeId
                                              .value -
                                          1]
                                      .gifts
                                      .length >=
                                  8
                              ? GridView.builder(
                                  itemCount: this
                                      ._categoryController
                                      .categories[this
                                              ._categoryController
                                              .activeId
                                              .value -
                                          1]
                                      .gifts
                                      .length,
                                  scrollDirection: Axis.horizontal,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 1.2,
                                    crossAxisCount: 2,
                                  ),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          this.giftSelectCode = this
                                              ._categoryController
                                              .categories[this
                                                      ._categoryController
                                                      .activeId
                                                      .value -
                                                  1]
                                              .gifts[index]['code'];
                                          this.giftSelect = this
                                              ._categoryController
                                              .categories[this
                                                      ._categoryController
                                                      .activeId
                                                      .value -
                                                  1]
                                              .gifts[index];
                                        });
                                      },
                                      child: _buildListGift(index),
                                    );
                                  })
                              : GridView.builder(
                                  itemCount: this
                                      ._categoryController
                                      .categories[this
                                              ._categoryController
                                              .activeId
                                              .value -
                                          1]
                                      .gifts
                                      .length,
                                  scrollDirection: Axis.vertical,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.9,
                                    crossAxisCount: 4,
                                  ),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          this.giftSelectCode = this
                                              ._categoryController
                                              .categories[this
                                                      ._categoryController
                                                      .activeId
                                                      .value -
                                                  1]
                                              .gifts[index]['code'];
                                          this.giftSelect = this
                                              ._categoryController
                                              .categories[this
                                                      ._categoryController
                                                      .activeId
                                                      .value -
                                                  1]
                                              .gifts[index];
                                        });
                                      },
                                      child: _buildListGift(index),
                                    );
                                  }),
                        ),
                        Container(
                          height: 38.h,
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [_buildLeftRuby(), _buildRight()],
                          ),
                        ),
                      ],
                    ),
                  ),
                  showSelectAmount
                      ? Positioned(
                          top: 150.h,
                          right: 100.w,
                          child: Container(
                            height: 134.h,
                            width: 69.w,
                            padding: EdgeInsets.all(5.w),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.r))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                for (var amount in [999, 299, 99, 10, 1])
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        this.amount = amount;
                                        this.showSelectAmount = false;
                                      });
                                    },
                                    child: Text(
                                      amount.toString(),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            )
          : Container(),
    );
  }

  Widget _buildListCategory() {
    return Obx(
      () => Container(
        height: 60.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: this
                  ._categoryController
                  .categories
                  .map(
                    (item) => new Padding(
                      padding: EdgeInsets.only(right: 25.w),
                      child: GestureDetector(
                        onTap: () {
                          this.giftSelectCode = '';
                          this._categoryController.changeCategory(item.order);
                        },
                        child: Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: item.order ==
                                    this._categoryController.activeId.value
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListGift(index) {
    return Container(
      color: this
                  ._categoryController
                  .categories[this._categoryController.activeId.value - 1]
                  .gifts[index]['code'] ==
              this.giftSelectCode
          ? Colors.white38
          : Colors.transparent,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 40.h,
                color: Colors.transparent,
                child: this
                                ._categoryController
                                .categories[
                                    this._categoryController.activeId.value - 1]
                                .gifts[index]['imageUrl'] !=
                            "" ||
                        this
                                ._categoryController
                                .categories[
                                    this._categoryController.activeId.value - 1]
                                .gifts[index]['imageUrl'] !=
                            null
                    ? Image(
                        image: NetworkImage(widget.storageUrl +
                            this
                                ._categoryController
                                .categories[
                                    this._categoryController.activeId.value - 1]
                                .gifts[index]['imageUrl']),
                      )
                    : Container(),
              ),
              Container(
                height: 20.h,
                margin: EdgeInsets.only(top: 5.h),
                child: _showPriceRow(index),
              ),
              Container(
                height: 25.h,
                child: Text(
                  this
                      ._categoryController
                      .categories[this._categoryController.activeId.value - 1]
                      .gifts[index]['name'],
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
          this
                      ._categoryController
                      .categories[this._categoryController.activeId.value - 1]
                      .gifts[index]["promotions"]
                      .length >
                  0
              ? Positioned(
                  top: 0,
                  left: 12.w,
                  child: Container(
                    width: 22.w,
                    child: Image.asset(
                      Assets.saleIcon,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildLeftRuby() {
    return Container(
      width: 200.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 20.h,
            child: Image.asset(
              Assets.diamondIcon,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Text(
            _categoryController.balance.value.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          IconButtonWidget(
            buttonColor: AppColors.pinkGradientButton,
            onPressed: () async {
              var topUpCache = await _topUpService.getTopUpCache();
              topUpCache.fold((l) => Modular.to.pushNamed(ViewerRoutes.payment_crypto), (data) {
                if(data != null){
                  Modular.to.pushNamed(ViewerRoutes.payment_information, arguments: {'information': data});
                } else {
                  Modular.to.pushNamed(ViewerRoutes.payment_crypto);
                }
              });
            },
            icon: Icons.add,
            iconSize: 20.sp,
            width: 25.w,
            height: 25.h,
          ),
        ],
      ),
    );
  }

  Widget _buildRight() {
    return Container(
      width: 150.w,
      height: 38.h,
      decoration: myBoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                this.showSelectAmount = !this.showSelectAmount;
              });
            },
            child: Container(
              width: 74.w,
              height: 38.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    this.amount.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp),
                  ),
                  Icon(
                    this.showSelectAmount
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (this.giftSelectCode != "") {
                if (this._categoryController.balance <
                    ( int.parse(this.giftSelect['price']) - getPromotionPrice(this.giftSelect))* this.amount) {
                  _handleShowErrorDialog(context, "live_not_balance".tr, false);
                  return;
                }
                await this._categoryController.sendGift(new GiftDto(
                    id: this.giftSelect['id'],
                    price: int.parse(this.giftSelect['price']),
                    promotionPrice: getPromotionPrice(this.giftSelect),
                    quantity: this.amount,
                    receiverId: widget.roomData.id.toString(),
                    streamId: widget.roomData.liveId.toString()));
                if (this._categoryController.errorMessage.value != "") {
                  String message =  "live_not_found_idol".tr;
                  if(this._categoryController.errorMessage.value  == "BALANCE_IS_NOT_ENOUGH"){
                    message = "live_not_balance".tr;
                  }
                  _handleShowErrorDialog(
                      context, message.tr, true);
                } else {
                  this._categoryController.balance.value =
                      getPromotionPrice(this.giftSelect) > 0
                          ? this._categoryController.balance.value -
                              getPromotionPrice(this.giftSelect) * this.amount
                          : this._categoryController.balance.value -
                              int.parse(this.giftSelect['price']) * this.amount;
                }
              }
            },
            child: Container(
              width: 74.w,
              height: 38.h,
              decoration: BoxDecoration(
                  color: this.giftSelectCode != ""
                      ? AppColors.pink1
                      : AppColors.whiteSmoke,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50.0.r),
                      bottomRight: Radius.circular(50.r))),
              padding: EdgeInsets.only(top: 7.w),
              child: Text(
                "live_send_gift".tr,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      color: Colors.transparent,
      border: Border.all(
          width: 1.r,
          color: this.giftSelectCode != ""
              ? AppColors.pink1
              : AppColors.whiteSmoke),
      borderRadius: BorderRadius.all(
        Radius.circular(50.r),
      ),
    );
  }

  void _handleShowErrorDialog(
      BuildContext context, String message, bool isError) async {
    isError
        ? ShowDialog().showMessage(
            context, message.tr, "live_manage_confirm_button".tr, () async {
            this._categoryController.errorMessage.value = "";
            Navigator.pop(context);
          })
        : ShowDialog().showMessage(
            context,
            message,
            "live_manage_confirm_button".tr,
            () async {
              Navigator.pop(context);
              Modular.to.pushNamed(ViewerRoutes.payment_crypto);
            },
            textButton2: "live_manage_cancel_button".tr,
            onButton2: () {
              Navigator.pop(context);
            });
  }

  int getPromotionPrice(gifts) {
    List promo = gifts["promotions"];
    if (promo.length > 0) {
      final check = promo.lastIndexWhere(
          (element) => checkDateTimeBetween(element) && !element["isDeleted"]);
      return check > -1 ? int.parse(promo[check]["promotionPrice"] ?? '0') : 0;
    } else {
      return 0;
    }
  }

  bool checkDateTimeBetween(data) {
    DateTime start = DateTime.parse(data["startTime"]).toLocal();
    DateTime end = DateTime.parse(data["endTime"]).toLocal();
    DateTime current = DateTime.now();
    if (start.isBefore(current) && end.isAfter(current)) {
      return true;
    } else {
      return false;
    }
  }

  Widget _showPriceRow(index) {
    final promotionPrice = getPromotionPrice(this
        ._categoryController
        .categories[this._categoryController.activeId.value - 1]
        .gifts[index]);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 15.h,
          child: Image.asset(
            Assets.diamondIcon,
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        Text(
          this
              ._categoryController
              .categories[this._categoryController.activeId.value - 1]
              .gifts[index]["price"],
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              color: Colors.white.withOpacity(0.5),
              decoration: promotionPrice > 0
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
        SizedBox(
          width: 10.w,
        ),
        promotionPrice > 0
            ? Text(
                getPromotionPrice(this
                        ._categoryController
                        .categories[this._categoryController.activeId.value - 1]
                        .gifts[index])
                    .toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              )
            : Container(),
      ],
    );
  }
}
