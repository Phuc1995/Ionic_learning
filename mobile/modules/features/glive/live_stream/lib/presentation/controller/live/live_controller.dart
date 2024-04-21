import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:live_stream/domain/entity/gift_entity.dart';
import 'package:live_stream/domain/entity/show_notification_in_app_entity.dart';
import 'package:live_stream/repository/live_api_repository.dart';
import 'package:logger/logger.dart';
import 'package:user_management/controllers/follow_controller.dart';
import 'package:user_management/dto/dto.dart';
import 'package:user_management/dto/idol_detail_dto.dart';

abstract class LiveRepository{

  Future leaveRoom();

  Future joinRoom();
}

class LiveController extends GetxController implements LiveRepository{
  LiveApiRepository _liveApi = Modular.get<LiveApiRepository>();
  FollowController _followController = Get.put(FollowController());
  FocusNode chatTextFocusNode = FocusNode();
  var gifts = <Gift>[].obs;
  var listRoom = <ViewerLiveRoomDto>[].obs;
  final logger = Modular.get<Logger>();
  var isShow = false.obs;
  var isLevelUp = false.obs;
  var isLiveTime = false.obs;
  var showChatInput = false.obs;
  var liveId = '0'.obs;
  var countTimeLive = "00:00:00".obs;
  var levelUpValue = "".obs;
  var giftReward = "".obs;
  var liveTimeDetail = ''.obs;
  var dataMessage = <LiveMessageDto>[].obs;
  var joinRoomTime = 0.obs;
  var listSuggest = [].obs;
  var isShownGiftBox = false.obs;
  var armorial = ''.obs;
  var countFollowingViewer = 0.obs;

  //swipe room
  var currentRoomIndex = 0.obs;
  var roomIndexNext = 0.obs;
  var currentRoom = ViewerLiveRoomDto().obs;
  var isEndLive = false.obs;

  //follow Idol
  var isReceiveNotify = false.obs;
  var idolDetail = IdolDetailDto(uuid: '').obs;

  //notification in app
  bool isNotifyShowing = false;
  var isMoveNotifyLive = false.obs;
  List<ShowNotificationInAppEntity> listNotify = [];
  var notificationInAppEntity = ShowNotificationInAppEntity(urlImage: '', nameIdol: '', uuidIdol: '', isBell: false).obs;

  //show receive exp
  var titleExp = ''.obs;
  var contentExp = ''.obs;

  // constructor:---------------------------------------------------------------
  LiveController();

  @override
  void onInit() async {
    Stream roomAdd = FirebaseStorage.getLiveRoom();
    Stream roomRemoved = FirebaseStorage.getLiveRoomRemoved();
    ViewerLiveRoomDto room = ViewerLiveRoomDto();
    List<ViewerLiveRoomDto> listRoomTmp = [];
    roomAdd.listen((snapshot) {
      if (snapshot.snapshot.value.length > 0 && snapshot.snapshot.value != null) {
        Map<dynamic, dynamic> snapshotMap = Map<dynamic, dynamic>.from(snapshot.snapshot.value);
        snapshotMap.forEach((key, value) {
          room = ViewerLiveRoomDto.fromMap(value[FirebaseStorage.metaData]);
          room.ruby = value[FirebaseStorage.ruby];
          room.viewCount = value[FirebaseStorage.viewCount];
          if(listRoomTmp.length > 0){
            int index = listRoomTmp.indexWhere((data) => data.id == room.id);
            if(!(index > -1)){
              listRoomTmp.add(room);
              settingRoomSuggest();
            }
          }else{
            listRoomTmp.add(room);
            settingRoomSuggest();
          }
        });
        this.listRoom.value = listRoomTmp;
        this.listRoom.refresh();
      }
    });

    roomRemoved.listen((snapshot) {
      if (snapshot.snapshot.value.length > 0 && snapshot.snapshot.value != null) {
        int index =  this.listRoom.indexWhere((ele) {
          return ele.id == snapshot.snapshot.key;
        } );
        if(index >= 0){
          this.listRoom.removeAt(index);
          this.listRoom.refresh();
        }
        int idolStreamingIndex =  _followController.idolStreaming.indexWhere((ele) => ele.uuid == snapshot.snapshot.key);
        if(idolStreamingIndex >= 0){
          _followController.idolStreaming.removeAt(idolStreamingIndex);
          _followController.idolStreaming.refresh();
        }
        int idolFollowedIndex =  _followController.idolList.indexWhere((ele) => ele.uuid == snapshot.snapshot.key);
        if(idolFollowedIndex >= 0){
          DateTime current = DateTime.now();
          _followController.idolList[idolFollowedIndex].isStreaming = false;
          _followController.idolList[idolFollowedIndex].latestLiveTime = current.toString();
          _followController.idolList[idolFollowedIndex].currentTime = current.toString();
          _followController.idolList.refresh();
        }
        settingRoomSuggest();
      }
    });

    super.onInit();
  }

  void settingRoomSuggest(){
    int currentIndex = this.currentRoomIndex.value;
    try {
      if(this.listRoom.length < 5 && currentIndex != this.listRoom.length-1){
        //case: only less than 4 room, will show next 3 room
        listSuggest.value = this.listRoom.sublist(currentIndex + 1, this.listRoom.length);
      } else if(currentIndex < this.listRoom.length-4){
        //case: not property about [0,4] and [last_room-4, last_room], will show next 4 room
        listSuggest.value = this.listRoom.sublist(currentIndex + 1, currentIndex + 5);
      } else if(currentIndex == this.listRoom.length && this.listRoom.length > 4){
        //case:the last room, will show the room between [0,4] of list room
        listSuggest.value = this.listRoom.sublist(0,4);
      } else if(currentIndex > this.listRoom.length - 5 && currentIndex < this.listRoom.length-1 && this.listRoom.length > 4 ){
        //case: 3 room last next room, will show the room after that
        listSuggest.value = this.listRoom.sublist(currentIndex+1, this.listRoom.length);
      } else if(this.listRoom.length < 5 && currentIndex == this.listRoom.length-1){
        listSuggest.value = this.listRoom.sublist(0,this.listRoom.length-1);
      } else {
        listSuggest.value = this.listRoom.sublist(0,4);
      }
    } catch (e){
      logger.e(e);
      if(this.listRoom.length > 1){
        listSuggest.value = this.listRoom.sublist(0,this.listRoom.length);
      } else {
        listSuggest.value = [];
      }
    }

  }

  resetAllController(){
    this.gifts.value = <Gift>[];
    this.isShow.value = false;
    this.liveId.value = '0';
    this.showChatInput.value = false;
    this.countTimeLive.value = "00:00:00";
    this.levelUpValue.value = "";
    this.giftReward.value = "";
    this.isLevelUp.value = false;
    this.isLiveTime.value = false;
    this.liveTimeDetail.value = '';
    this.isEndLive.value = false;
}

  void addGift(Gift gift) {
    this.gifts.add(gift);
    this.gifts.refresh();
  }

  void removeGift(index) {
    this.gifts.removeAt(index);
    this.gifts.refresh();
  }

  Future handleSwipeChannel(bool isNext, String userUuid) async {
    if(!isNext){
      if(this.currentRoomIndex.value <= 0){
        await jumpToPage(this.listRoom.length-1, userUuid);
      } else {
        await jumpToPage(this.currentRoomIndex.value-1, userUuid);
      }
    }
    if(isNext){
      if(this.currentRoomIndex.value >= this.listRoom.length-1 && !this.isEndLive.value){
        await jumpToPage(0, userUuid);
      } else if(this.currentRoomIndex.value == this.listRoom.length-1 && this.isEndLive.value){
        await jumpToPage(this.currentRoomIndex.value, userUuid);
        this.currentRoomIndex.value +=1;
      } else {
        await jumpToPage(this.currentRoomIndex.value+1, userUuid);
      }
    }
  }

  Future jumpToPage(int roomNext, String userUuid) async {
    leaveRoom();
    this.currentRoomIndex.value = roomNext;
    this.currentRoom.value = this.listRoom[this.currentRoomIndex.value];
    this.currentRoom.refresh();
    _followController.getIdolDetail(this.currentRoom.value.id);
    if(!this.isEndLive.value) joinRoom();
    this.dataMessage.clear();
  }

  @override
  Future leaveRoom() async {
    final userUuid = Modular.get<SharedPreferenceHelper>().getUserUuid.toString();
    await this._liveApi.leaveRoom(this.currentRoom.value.id, userUuid)
      ..fold((l) =>  {
        Modular.to.navigate(ViewerRoutes.home,  arguments: {'currentPage' : 0})
      }, (r) => null);
  }

  @override
  Future joinRoom() async {
    this..joinRoomTime.value = DateTime.now().millisecondsSinceEpoch;
    final userUuid = Modular.get<SharedPreferenceHelper>().getUserUuid.toString();
    await this._liveApi.joinRoom(this.currentRoom.value.id, userUuid)
      ..fold((l) =>  {
      Modular.to.navigate(ViewerRoutes.home, arguments: {'currentPage' : 0})
      }, (r) => null);
  }

  List<Gift> getAllGift(){
    return gifts;
  }

  Future followIdol(String uuidIdol) async {
    _followController.followIdol(uuidIdol).then((data) {
      _followController.isFollowing.value = true;
    });
  }

  Future unfollowIdol(String uuidIdol) async {
    _followController.unfollowIdol(uuidIdol).then((data) {
      _followController.isFollowing.value = false;
      this.isReceiveNotify.value = false;
    });
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
