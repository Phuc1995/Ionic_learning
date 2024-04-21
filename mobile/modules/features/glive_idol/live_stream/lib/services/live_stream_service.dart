import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:live_stream/dto/dto.dart';
import 'package:live_stream/repositories/repositories.dart';
import 'package:logger/logger.dart';
import 'package:user_management/domain/entity/request/live-session.dart';

class LiveStreamService {
  final logger = Modular.get<Logger>();

  Future<Either<Failure, GatewayResponse>> createLiveSession(LiveSessionDto dto) async {
    final _liveApi = Modular.get<LiveStreamRepository>();
    final res = await _liveApi.createLiveSession(dto);
    return res;
  }

  Future<Either<Failure, GatewayResponse>> endLiveSession(String id, String streamId) async {
    final _liveApi = Modular.get<LiveStreamRepository>();
    final res = await _liveApi.endLiveSession(id, streamId);
    return res;
  }

  Future<Either<Failure, GatewayResponse>> heartBeat(String id) async {
    final _liveApi = Modular.get<LiveStreamRepository>();
    final res = await _liveApi.heartBeat(id);
    return res;
  }

  Future<Either<Failure, GatewayResponse>> sendMessage(MessageDto dto) async {
    final _liveApi = Modular.get<MessageRepository>();
    final res = await _liveApi.sendMessage(dto);
    return res;
  }

  Future<Either<Failure, bool>> addViewerPermission(AddViewerPermissionDto params) async {
    final _liveApi = Modular.get<PrivacyRepository>();
    final either = await _liveApi.viewerPermission(params);
    return either.fold((failure) => Left(failure), (data) {
      return Right(true);
    });
  }

  Future<Either<Failure, Map>> getListViewerPermission(ListViewerPermissionDto params) async {
    final _liveApi = Modular.get<PrivacyRepository>();
    final either = await _liveApi.getListPermission(params);

    return either.fold((failure) => Left(failure), (data) {
      if(data.messageCode == "GET_LIST_VIEWER_PERMISSION_SUCCESS"){
        List<ViewerPermissionDto> listItem = <ViewerPermissionDto>[];
        data.data['items'].forEach((json){
          ViewerPermissionDto item = ViewerPermissionDto.fromMap(json);
          listItem.add(item);
        });
        Map result = new Map();
        result['items'] = listItem;
        result['totalPages'] = data.data['meta']['totalPages'];
        return Right(result);
      }
      return Left(LocalFailure());
    });
  }
}
