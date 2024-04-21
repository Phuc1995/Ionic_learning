import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:live_stream/dto/gift_dto.dart';
import 'package:logger/logger.dart';

class LiveStreamController extends GetxController {
  final logger = Modular.get<Logger>();
  FocusNode chatTextFocusNode = FocusNode();
  late Timer _timer;

  var gifts = <GiftDto>[].obs;
  var giftHistory = <GiftDto>[].obs;

  var liveTimeDetail = ''.obs;
  var liveId = '0'.obs;
  var countTimeLive = "00:00:00".obs;
  var levelUpValue = "".obs;
  var giftReward = "".obs;

  var isLevelUp = false.obs;
  var isLiveTime = false.obs;
  var isShow = false.obs;
  var showChatInput = false.obs;
  var isShowGiftHistory = false.obs;
  var isShowIconGift = false.obs;
  var isServerError = false.obs;


  //show receive exp
  var titleExp = ''.obs;
  var contentExp = ''.obs;

  // constructor:---------------------------------------------------------------
  LiveStreamController();

  @override
  void onInit() async {
    super.onInit();
  }

  resetLiveController(){
    this.gifts.clear();
    this.giftHistory.clear();
    this.liveId.value = '0';
    this.countTimeLive.value = "00:00:00";
    this.levelUpValue.value = "";
    this.giftReward.value = "";
    this.liveTimeDetail.value = '';
    this.isLevelUp.value = false;
    this.isLiveTime.value = false;
    this.showChatInput.value = false;
    this.isShow.value = false;
    this.isShowGiftHistory.value = false;
    this.isShowIconGift.value = false;
    this.isServerError.value = false;
    _timer.cancel();
}

  void addGift(GiftDto gift) {
    this.gifts.add(gift);
    this.gifts.refresh();
  }

  void removeGift(index) {
    this.gifts.removeAt(index);
    this.gifts.refresh();
  }

  List<GiftDto> getAllGift(){
    return this.gifts;
  }


  void addGiftHistory(GiftDto gift) {
    if(this.isShowIconGift.value == false){
      this.isShowIconGift.value = true;
    }
    this.giftHistory.add(gift);
    this.giftHistory.refresh();
  }

  void setUpCountTime() {
    countTimeLive.value = "00:00:00";
    DateTime? timeStart = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      final DateTime now = DateTime.now();
      String seconds = now.difference(timeStart).inSeconds.remainder(60).toString().length == 1 ? "0" + now.difference(timeStart).inSeconds.remainder(60).toString() : now.difference(timeStart).inSeconds.remainder(60).toString();
      String minutes = now.difference(timeStart).inMinutes.remainder(60).toString().length == 1 ? "0" + now.difference(timeStart).inMinutes.remainder(60).toString() : now.difference(timeStart).inMinutes.remainder(60).toString() ;
      String hours = now.difference(timeStart).inHours.toString().length == 1 ? "0" + now.difference(timeStart).inHours.toString() : now.difference(timeStart).inHours.toString();
      this.countTimeLive.value = hours + ":" +  minutes + ":" + seconds;
    });
  }

  void cancelTimer(){
    this._timer.cancel();
  }
}
class LiveDetail {
  int? liveTime;
  int? exp;

  LiveDetail(this.liveTime, this.exp);

  factory LiveDetail.fromJson(dynamic json) {
    return LiveDetail(json['liveTime'] as int, json['exp'] as int);
  }

  @override
  String toString() {
    return '{ ${this.liveTime}, ${this.exp} }';
  }


}
