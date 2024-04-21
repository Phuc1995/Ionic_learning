import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:live_stream/domain/entity/category_entity.dart';
import 'package:live_stream/domain/entity/gift_dto.dart';
import 'package:live_stream/domain/entity/message_dto.dart';
import 'package:live_stream/domain/usecase/list_viewer_permission.dart';
import 'package:live_stream/domain/usecase/viewer_permission.dart';
import 'package:user_management/dto/dto.dart';

abstract class LiveApiRepository {
  Future<Either<Failure,GatewayResponse>> createLiveSession(LiveSessionDto dto);
  Future<Either<Failure,GatewayResponse>> endLiveSession(String id, String streamId);
  Future<Either<Failure,GatewayResponse>> heartBeat(String id);
  Future<Either<Failure,GatewayResponse>> viewerPermission(AddViewerPermissionParam param);
  Future<Either<Failure,GatewayResponse>> getListPermission(ListViewerPermissionParam param);
  Future<Either<Failure,GatewayResponse>> sendMessage(MessageDto dto);
  Future<Either<Failure,GatewayResponse>> joinRoom(String roomId, String userUuid);
  Future<Either<Failure,GatewayResponse>> leaveRoom(String roomId, String userUuid);
  Future<Either<Failure,List<CategoryList>>> getCategory();
  Future<Either<Failure,String>> sendGift(GiftDto giftDto);
}
