import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:live_stream/domain/entity/all_list_viewer_permission_entity.dart';
import 'package:live_stream/domain/usecase/list_viewer_permission.dart';
import 'package:live_stream/domain/usecase/viewer_permission.dart';
import 'package:live_stream/repository/live_api_repository.dart';
import 'package:logger/logger.dart';

abstract class LiveStreamServiceAbs{
  Future<Either<Failure, bool>> addViewerPermission(AddViewerPermissionParam params);
  Future<Either<Failure, Map>> getListViewerPermission(ListViewerPermissionParam params);
}

class LiveStreamService implements LiveStreamServiceAbs{
  final logger = Modular.get<Logger>();

  Future<Either<Failure, bool>> addViewerPermission(AddViewerPermissionParam params) async {
    final _liveApi = Modular.get<LiveApiRepository>();
    final either = await _liveApi.viewerPermission(params);
    return either.fold((failure) => Left(failure), (data) {
      return Right(true);
    });
  }

  Future<Either<Failure, Map>> getListViewerPermission(ListViewerPermissionParam params) async {
    final _liveApi = Modular.get<LiveApiRepository>();
    final either = await _liveApi.getListPermission(params);

    return either.fold((failure) => Left(failure), (data) {
      if(data.messageCode == "GET_LIST_VIEWER_PERMISSION_SUCCESS"){
        List<AllListViewerPermissionEntity> listItem = <AllListViewerPermissionEntity>[];
        data.data['items'].forEach((json){
          AllListViewerPermissionEntity item = AllListViewerPermissionEntity.fromMap(json);
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

  Future<Either<Failure, GatewayResponse>> heartBeat(String id) async {
    final _liveApi = Modular.get<LiveApiRepository>();
    final res = await _liveApi.heartBeat(id);
    return res;
  }
}
