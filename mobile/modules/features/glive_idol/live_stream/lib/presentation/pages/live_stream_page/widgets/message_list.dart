import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_stream/dto/gift_dto.dart';
import 'package:live_stream/controllers/live_stream_controller.dart';
import 'package:live_stream/presentation/pages/live_stream_page/widgets/message_item.dart';
import 'package:user_management/domain/entity/response/profile_response.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageList extends StatelessWidget {
  final List<LiveMessageDto> data;
  final ProfileResponse profile;
  final String storageUrl;

  const MessageList({
    Key? key,
    required this.profile,
    required this.data,
    required this.storageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LiveStreamController _liveController = Get.put(LiveStreamController());
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(top: 110.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder(
            stream: FirebaseStorage.getLiveMessage(this.profile.uuid),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData && !snapshot.hasError && snapshot.data.snapshot.value != null) {
                Map<String, dynamic> snapshotMap =
                    Map<String, dynamic>.from(snapshot.data.snapshot.value);
                LiveMessageDto message = LiveMessageDto.fromMap(snapshotMap);
                message.key = snapshot.data.snapshot.key;
                if (!checkExitKey(message.key, data)) {
                  data.insert(0, message);
                  if (data.length > 50) {
                    data.removeAt(49);
                  }
                  if (message.type == 'gift') {
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      _liveController.addGift(
                        new GiftDto(
                          userName: message.gId,
                          idMessage: message.timestamp.toString(),
                          giftImage: message.giftImage.toString(),
                          giftAnimation: message.giftAnimation.toString(),
                          giftName: message.giftName.toString(),
                          quantity: message.quantitySent.toString(),
                          size: message.size.toString(),
                          userImage: message.imageUrl.toString(),
                        ),
                      );
                      _liveController.addGiftHistory(
                        new GiftDto(
                          userName: message.gId,
                          idMessage: message.timestamp.toString(),
                          giftImage: message.giftImage.toString(),
                          giftName: message.giftName.toString(),
                          giftAnimation: message.giftAnimation.toString(),
                          quantity: message.quantitySent.toString(),
                          size: message.size.toString(),
                          userImage: message.imageUrl.toString(),
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
                            return MessageItem(
                              message: data[index],
                              storageUrl: storageUrl,
                            );
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
      ),
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
}
