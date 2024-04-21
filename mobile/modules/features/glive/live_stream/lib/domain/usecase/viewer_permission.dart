import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:live_stream/domain/service/live_stream_service.dart';

class AddViewerPermission extends UseCase<bool, AddViewerPermissionParam>{
  late Either<Failure, bool> _response;

  Either<Failure, bool> get response => _response;

  @override
  Future<Either<Failure, bool>> call(AddViewerPermissionParam param) async{
    final liveService = Modular.get<LiveStreamService>();
    _response = await liveService.addViewerPermission(param);
    return await _response;
  }
}

class AddViewerPermissionParam extends Equatable{
  final String userUuid;
  final String title;
  final bool isRemove;

  AddViewerPermissionParam({required this.userUuid, required this.title, required this.isRemove});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  Map<String, dynamic> toJson() => {
    "userUuid": userUuid,
    "title": title,
  };
}

class ViewerPermissionType {
  ViewerPermissionType._();

  static const String LIVE_ROOM_LOCKED_CHAT = "LIVE_ROOM_LOCKED_CHAT";
  static const String LIVE_ROOM_MANAGER = "LIVE_ROOM_MANAGER";
}
