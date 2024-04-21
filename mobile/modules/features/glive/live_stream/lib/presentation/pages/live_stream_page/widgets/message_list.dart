import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:live_stream/domain/entity/gift_entity.dart';
import 'package:live_stream/presentation/controller/live/category_controller.dart';
import 'package:live_stream/presentation/controller/live/live_controller.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/message_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/dto/dto.dart';
import 'package:user_management/repositorise/user_info_api_repository.dart';

class MessageList extends StatelessWidget {
  final List<LiveMessageDto> data;
  final String roomId;
  final String storageUrl;
  final String gId;

  const MessageList({
    Key? key,
    required this.roomId,
    required this.data,
    required this.storageUrl,
    required this.gId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LiveController _liveController = Get.put(LiveController());
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder(
          stream: FirebaseStorage.getLiveMessage(this.roomId),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && !snapshot.hasError && snapshot.data.snapshot.value != null) {
              Map<String, dynamic> snapshotMap = Map<String, dynamic>.from(snapshot.data.snapshot.value);
              LiveMessageDto message = LiveMessageDto.fromMap(snapshotMap);
              message.key = snapshot.data.snapshot.key;
              if (!checkExitKey(message.key, data) && message.timestamp! >= _liveController.joinRoomTime.value ) {
                  data.insert(0, message);
                  if (data.length > 50 ) {
                    data.removeAt(49);
                  }
                  if (message.type == 'gift') {
                    WidgetsBinding.instance!.addPostFrameCallback((_) async {
                      if(message.gId == gId.substring(gId.lastIndexOf("-") + 1) ){
                        await fetchData();
                      }
                      _liveController.addGift(
                        new Gift(
                          userName: message.gId,
                          idMessage: message.timestamp.toString(),
                          giftImage: message.giftImage.toString(),
                          giftAnimation: message.giftAnimation.toString(),
                          giftName: message.giftName.toString(),
                          quantity: message.quantitySent.toString(),
                          size: message.size.toString(),
                        ),
                      );
                    });
                  }
              }
              return Container(
                height: MediaQuery.of(context).size.height * 0.35,
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                  minWidth: 20.w,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: ClipRRect(
                  child: ShaderMask(
                    shaderCallback: (Rect rect) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.purple,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.purple
                        ],
                        stops: [0.1, 0.3, 1.0, 0.1], // 10% purple, 80% transparent, 10% purple
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.dstOut,
                    child: ListView.builder(
                        reverse: true,
                        padding: EdgeInsets.only(top: 60.h, bottom: 10.h),
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return MessageItem(message: data[index], storageUrl: storageUrl,);
                        }),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }

  bool checkExitKey(key, data) {
    var contain = data.where((element) => element.key == key.toString());
    if (contain.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future fetchData() async {
    final UserInfoApiRepository _accountInfoApi = Modular.get<UserInfoApiRepository>();
    CategoryController _categoryController = Get.put(CategoryController());
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
}
