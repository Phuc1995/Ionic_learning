import 'package:common_module/common_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:live_stream/presentation/controller/live/live_controller.dart';
import 'package:user_management/constants/assets.dart';
import 'package:user_management/dto/dto.dart';
import 'package:user_management/dto/idol_detail_dto.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../service/services.dart';

class FollowController extends GetxController {
  FollowController();

  final _followService = Modular.get<FollowIdolService>();
  final _idolService = Modular.get<IdolService>();
  int limitStreaming = 10;
  int currentPageStreaming = 1;
  int totalPageStreaming = 1;
  int limitFollowed = 20;
  int currentFollowed = 1;
  int totalFollowed = 1;
  var isReceiveNotify = false.obs;
  var idolList = <IdolDetailDto>[].obs;
  var idolStreaming = <IdolDetailDto>[].obs;
  var idolDetail = IdolDetailDto(
    uuid: '',
    skills: [],
    birthdate: '',
    country: '',
    email: '',
    experiencePoint: 0,
    follows: [],
    fullName: '',
    gender: 0,
    gId: '',
    imageUrl: '',
    intro: '',
    province: '',
    isBanned: false,
    isStreaming: false,
    latestLiveTime: "",
    currentTime: "",
    isFollowed: false,
    isReceiveNotify: false,
    level: LevelIdolEntity(key: '', name: '',  medal: ''),
  ).obs;
  var isLoading = false.obs;
  var isFollowing = true.obs;
  var countFollowingViewer = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getIdolList() async {
    isLoading = true.obs;
    var either = await _followService.getIdolsFollowed(IdolFollowedParamDto(page: this.currentFollowed, limit: this.limitFollowed));
    either.fold((failure) {
      this.isLoading.value = false;
    }, (data) {{
      this.isLoading.value = false;
      idolList.addAll(data.getItems()!);
      this.currentFollowed = data.getPageData()!.currentPage;
      this.totalFollowed = data.getPageData()!.totalPages;
      idolList.refresh();
    }});
  }

  Future<void> getIdolStreaming() async {
    var either = await _followService.getIdolFollowedStreaming(IdolFollowedStreamingParamDto(page: this.currentPageStreaming, limit: this.limitStreaming));
    either.fold((l) => null, (data) {{
      this.idolStreaming.addAll(data.getItems()!);
      this.currentPageStreaming = data.getPageData()!.currentPage;
      this.totalPageStreaming = data.getPageData()!.totalPages;
      idolStreaming.refresh();
    }});
  }

  Future<void> getIdolDetail(String uuidIDol) async {
    final userUuid = Modular.get<SharedPreferenceHelper>().getUserUuid.toString();
    await _idolService.getIdolDetail(uuidIDol).then((value) {
      value.fold((l) => null, (response) {
        this.idolDetail.value = response;
        int index = response.follows!.indexWhere((ele) => ele.viewerUuid == userUuid);
        if(index >= 0) {
          this.isFollowing.value = true;
        } else{
          this.isFollowing.value = false;
        };
        this.isReceiveNotify.value = response.isReceiveNotify??false;
        this.idolDetail.refresh();
      });
    });
  }

  Future<void> followIdol(String uuidIdol) async {
    _followService.followIdol(uuidIdol).then((data) {
      this.isFollowing.value = true;
      int indexIdol = this.idolList.indexWhere((ele) => ele.uuid == uuidIdol);
      if(indexIdol >= 0) this.idolList[indexIdol].isFollowed = true;
      this.idolList.refresh();
    });
  }

  Future<void> unfollowIdol(String uuidIdol) async {
    _followService.unfollowIdol(uuidIdol).then((data) {
      this.isFollowing.value = false;
      int indexIdol = this.idolList.indexWhere((ele) => ele.uuid == uuidIdol);
      if(indexIdol >= 0) this.idolList[indexIdol].isFollowed = false;
      this.isReceiveNotify.value = false;
      this.idolList.refresh();
    });
  }

  void resetPaging() {
    this.idolStreaming.clear();
    this.idolList.clear();
    this.currentPageStreaming = 1;
    this.totalPageStreaming = 1;
    this.currentFollowed = 1;
    this.totalFollowed = 1;
  }

  Future<void> receiveBellIdol({required BuildContext context, required String uuidIdol, required bool isReceiveNotify, required String storageUrl, required String imageUrl}) async {
    _followService.receiveBellIdol(IdolBellParamDto(uuidIdol: uuidIdol, bell: isReceiveNotify)).then((data) {
      data.fold((l) => null, (result) {
        if(result){
          ShowDialog().showEnableNotifyDialog(context,  defaultAvatar: Assets.defaultAvatar, storageUrl: storageUrl , fileUrl: imageUrl, icon: Align(
              alignment: Alignment.topCenter,
              child: Container(
                  margin: EdgeInsets.only(left: 65.w),
                  child: Image.asset(Assets.bell_white_stroke, width: 22.w, height: 22.h,))));
        }
        this.isReceiveNotify.value = result;
      });
    });
  }

  Future<void> getCountFollowingViewer(String uuidViewer) async {
    await _followService.countFollowingViewer(uuidViewer)..fold((l) => null, (res) {
      this.countFollowingViewer.value = res.data['following'];
    });
  }

  void initFollowingList(ScrollController scrollController) {
    timeago.setLocaleMessages('vi', timeago.ViMessages());
    this.getIdolList();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (this.currentFollowed < this.totalFollowed) {
          this.currentFollowed += 1;
          this.getIdolList();
        }
      }
    });
  }

  void initIdolStreaming(ScrollController scrollController) {
    this.resetPaging();
    this.getIdolStreaming();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (this.currentPageStreaming < this.totalPageStreaming) {
          this.currentPageStreaming += 1;
          this.getIdolStreaming();
        }
      }
    });
  }

  Future<void> navigateIdolDetail(int index, LiveController _liveController) async {
    if(this.idolList[index].isStreaming!){
      int roomIndex = _liveController.listRoom.indexWhere((ele) => ele.id == this.idolList[index].uuid);
      if(roomIndex >= 0){
        _liveController.currentRoom.value = _liveController.listRoom[roomIndex];
        _liveController.currentRoom.refresh();
        Modular.to.pushNamed(ViewerRoutes.live_channel_idol, arguments: {'roomData': _liveController.currentRoom.value});
      }
    } else {
      await this.getIdolDetail(this.idolList[index].uuid);
      Modular.to.pushNamed(ViewerRoutes.idol_detail, arguments: {'uuidIdol' : this.idolList[index].uuid, 'isBanned' : this.idolList[index].isBanned});
    }
  }

  String timeLiveAgo({String? currentTime, String? latestLiveTime}) {
    final difference = DateTime.parse(currentTime??"").difference(DateTime.parse(latestLiveTime??""));
    return timeago.format(DateTime.parse(currentTime??"").subtract(difference), locale: 'vi').replaceAll("khoảng", "").replaceAll("một", "1");
  }
}
